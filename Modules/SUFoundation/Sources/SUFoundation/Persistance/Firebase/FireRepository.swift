//
//  FireRepository.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 30.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import Combine
import FirebaseStorage
import FirebaseCore
import FirebaseFirestore


/*
Workspace:
    - id: String
    - ownerId: String
    - documents: [String]
    - members: [WorkspaceMember]
    - title: String
    - emoji: String
    - dateCreated: Date

WorkspaceMember:
    - id: String
    - permission: Int

Document:
    - id: String
    - workspaceId: String
    - ownerId: String
    - title: String
    - text: String
    - emoji: String
    - dateCreated: Date
    - dateEdited: Date
 */

public final class FireRepository {

    enum FetchError: Error {
        case cantLoadList
        case cantLoadEntity
        case cantCreate
    }

    private let firestore: Firestore
    private let storage: Storage
    private var listeners: [String : ListenerRegistration] = [:]

    public init(
        firestore: Firestore,
        storage: Storage
    ) {
        self.firestore = firestore
        self.storage = storage
    }

    deinit {
        listeners.forEach { $0.value.remove() }
    }
}

// MARK: - Private interface

private extension FireRepository {

    func users() -> CollectionReference {
        firestore
            .collection("users")
    }

    func workspaces() -> CollectionReference {
        firestore
            .collection("workspaces")
    }

    func documents() -> CollectionReference {
        firestore
            .collection("documents")
    }

    func userRef(id: String) -> DocumentReference {
        users()
            .document(id)
    }

    func userRef(email: String) async throws -> DocumentReference? {
        try await users()
            .whereField("email", isEqualTo: email)
            .getDocuments()
            .documents
            .first?
            .reference
    }

    func workspaceRef(id: String) -> DocumentReference {
        workspaces()
            .document(id)
    }

    func documentRef(id: String) -> DocumentReference {
        documents()
            .document(id)
    }
}

extension FireRepository: Repository {

    // MARK: - Space

    public func workspaces(for userId: String) async throws -> [SUShallowWorkspace] {
        guard let workspaces = try await userRef(id: userId).getDocument().get("workspaces") as? Array<String> else { throw FetchError.cantLoadList }

        let result: [SUShallowWorkspace] = try await workspaces.asyncCompactMap { workspaceId in
            let workspace = try await workspaceRef(id: workspaceId).getDocument()

            guard let title = workspace.get("title") as? String else { return nil }
            guard let emoji = workspace.get("emoji") as? String else { return nil }
            guard let documentsCount = workspace.get("documentsCount") as? Int else { return nil }
            guard let membersCount = workspace.get("membersCount") as? Int else { return nil }

            return SUShallowWorkspace(
                meta: SUWorkspaceMeta(
                    id: workspaceId
                ),
                title: title,
                emoji: emoji,
                documentsCount: documentsCount,
                membersCount: membersCount
            )
        }
        return result
    }

    public func startListenSpace(
        userId: String,
        callback: @escaping ([SUShallowWorkspace]) -> Void
    ) async throws {
        guard let userWorkspaces = try await userRef(id: userId).getDocument().get("workspaces") as? Array<String> else { throw FetchError.cantLoadList }

        let listener = workspaces()
            .whereField("id", in: userWorkspaces)
            .addSnapshotListener { snapshot, error in
                guard let workspaces = snapshot?.documents else { return }
                Task {
                    let result: [SUShallowWorkspace] = await workspaces.asyncCompactMap { workspace in

                        guard let title = workspace.get("title") as? String else { return nil }
                        guard let emoji = workspace.get("emoji") as? String else { return nil }
                        guard let documentsCount = workspace.get("documentsCount") as? Int else { return nil }
                        guard let membersCount = workspace.get("membersCount") as? Int else { return nil }

                        return SUShallowWorkspace(
                            meta: SUWorkspaceMeta(
                                id: workspace.documentID
                            ),
                            title: title,
                            emoji: emoji,
                            documentsCount: documentsCount,
                            membersCount: membersCount
                        )
                    }
                    callback(result)
                }
            }
        listeners[userId] = listener
    }

    // MARK: - Workspace

    public func createWorkspace(with title: String, userId: String) async throws -> String {
        let workspaceRef = workspaces()
            .document()
        let userRef = userRef(id: userId)
        try await _ = [
            workspaceRef
                .setData([
                    "id" : workspaceRef.documentID,
                    "ownerId" : userId,
                    "documents" : [],
                    "members" : [
                        [
                            "id" : userId,
                            "permission" : 0
                        ]
                    ],
                    "title" : title,
                    "emoji" : "",
                    "dateCreated" : Timestamp(date: Date.now),
                    "documentsCount" : 0,
                    "membersCount" : 1
                ]),
            userRef
                .updateData([
                    "workspaces" : FieldValue.arrayUnion([workspaceRef.documentID])
                ])
        ]
        return workspaceRef.documentID
    }

    public func startListenWorkspace(
        workspaceId: String,
        callback: @escaping (SUWorkspace) -> Void
    ) {
        let listener = workspaceRef(id: workspaceId)
            .addSnapshotListener { [self] workspaceSnapshot, error in
                guard let workspaceSnapshot = workspaceSnapshot else { return }
                Task {
                    do {
                        guard let ownerId = workspaceSnapshot.get("ownerId") as? String else { throw FetchError.cantLoadEntity }
                        guard let documents = workspaceSnapshot.get("documents") as? Array<String> else { throw FetchError.cantLoadEntity }
                        guard let members = workspaceSnapshot.get("members") as? Array<[String: Any]> else { throw FetchError.cantLoadEntity }
                        guard let title = workspaceSnapshot.get("title") as? String else { throw FetchError.cantLoadEntity }
                        guard let emoji = workspaceSnapshot.get("emoji") as? String else { throw FetchError.cantLoadEntity }
                        guard let dateCreated = workspaceSnapshot.get("dateCreated") as? Timestamp else { throw FetchError.cantLoadEntity }
                        
                        let shallowDocuments: [SUShallowDocument] = try await documents.asyncCompactMap { documentId in
                            let document = try await documentRef(id: documentId).getDocument()
                            
                            guard let title = document.get("title") as? String else { return nil }
                            guard let emoji = document.get("emoji") as? String else { return nil }
                            guard let dateCreated = document.get("dateCreated") as? Timestamp else { return nil }
                            
                            return SUShallowDocument(
                                meta: SUDocumentMeta(
                                    id: documentId,
                                    workspaceId: workspaceId
                                ),
                                title: title,
                                emoji: emoji,
                                dateCreated: dateCreated.dateValue()
                            )
                        }
                        let workspaceMembers: [SUShallowWorkspaceMember] = members.compactMap { memberDict in
                            
                            guard let id = memberDict["id"] as? String else { return nil }
                            guard let permission = memberDict["permission"] as? Int else { return nil }
                            
                            return SUShallowWorkspaceMember(
                                id: id,
                                permission: permission
                            )
                        }
                        let workspace = SUWorkspace(
                            meta: SUWorkspaceMeta(
                                id: workspaceId
                            ),
                            ownerId: ownerId,
                            title: title,
                            documents: shallowDocuments,
                            members: workspaceMembers,
                            emoji: emoji,
                            dateCreated: dateCreated.dateValue()
                        )
                        callback(workspace)
                    } catch {
                        
                    }
                }
            }
        listeners[workspaceId] = listener
    }

    public func workspace(with id: String) async throws -> SUWorkspace {
        let workspaceSnapshot = try await workspaceRef(id: id).getDocument()

        guard let ownerId = workspaceSnapshot.get("ownerId") as? String else { throw FetchError.cantLoadEntity }
        guard let documents = workspaceSnapshot.get("documents") as? Array<String> else { throw FetchError.cantLoadEntity }
        guard let members = workspaceSnapshot.get("members") as? Array<[String: Any]> else { throw FetchError.cantLoadEntity }
        guard let title = workspaceSnapshot.get("title") as? String else { throw FetchError.cantLoadEntity }
        guard let emoji = workspaceSnapshot.get("emoji") as? String else { throw FetchError.cantLoadEntity }
        guard let dateCreated = workspaceSnapshot.get("dateCreated") as? Timestamp else { throw FetchError.cantLoadEntity }

        let shallowDocuments: [SUShallowDocument] = try await documents.asyncCompactMap { documentId in
            let document = try await documentRef(id: documentId).getDocument()

            guard let title = document.get("title") as? String else { return nil }
            guard let emoji = document.get("emoji") as? String else { return nil }
            guard let dateCreated = document.get("dateCreated") as? Timestamp else { return nil }

            return SUShallowDocument(
                meta: SUDocumentMeta(
                    id: documentId,
                    workspaceId: id
                ),
                title: title,
                emoji: emoji,
                dateCreated: dateCreated.dateValue()
            )
        }
        let workspaceMembers: [SUShallowWorkspaceMember] = members.compactMap { memberDict in

            guard let id = memberDict["id"] as? String else { return nil }
            guard let permission = memberDict["permission"] as? Int else { return nil }

            return SUShallowWorkspaceMember(
                id: id,
                permission: permission
            )
        }
        return SUWorkspace(
            meta: SUWorkspaceMeta(
                id: id
            ),
            ownerId: ownerId,
            title: title,
            documents: shallowDocuments,
            members: workspaceMembers,
            emoji: emoji,
            dateCreated: dateCreated.dateValue()
        )
    }

    public func updateWorkspace(id: String, title: String) async throws {
        let workspaceRef = workspaceRef(id: id)

        try await workspaceRef
            .updateData([
                "title" : title
            ])
    }

    public func updateWorkspace(id: String, emoji: String) async throws {
        let workspaceRef = workspaceRef(id: id)

        try await workspaceRef
            .updateData([
                "emoji" : emoji
            ])
    }

    public func deleteWorkspace(id: String, userId: String) async throws {
        let userRef = userRef(id: userId)
        let workspaceRef = workspaceRef(id: id)

        try await _ = [
            userRef
                .updateData([
                    "workspaces" : FieldValue.arrayRemove([id])
                ]),
            documents()
                .whereField("workspaceId", isEqualTo: id)
                .getDocuments()
                .documents
                .forEach { $0.reference.delete() },
            workspaceRef.delete()
        ]
    }

  public func members(workspaceId: String, callback: @escaping ([SUWorkspaceMember]) -> Void) {
    let listener = workspaceRef(id: workspaceId)
      .addSnapshotListener { snapshot, error in
        Task {
          do {
            guard let snapshot = snapshot else { return }
            guard let members = snapshot.get("members") as? Array<[String: Any]> else { return }

            let workspaceMembers: [SUWorkspaceMember] = try await members.asyncCompactMap { memberDict in

              guard let id = memberDict["id"] as? String else { return nil }
              guard let permission = memberDict["permission"] as? Int else { return nil }

              let userRef = try await self.userRef(id: id).getDocument()

              guard let username = userRef.get("username") as? String else { return nil }
              guard let email = userRef.get("email") as? String else { return nil }
              let avatarPath = userRef.get("avatarPath") as? String

              return SUWorkspaceMember(
                user: SUUser(
                  meta: SUUserMeta(
                    id: id
                  ),
                  username: username,
                  email: email,
                  invites: [],
                  avatarPath: avatarPath
                ),
                permission: SUWorkspacePermission(rawValue: permission)!
              )
            }

            callback(workspaceMembers)
          } catch {
            
          }
        }
      }
    listeners[workspaceId] = listener
  }

  // MARK: - Invites

  public func sendInvite(email: String, workspaceId: String) async throws {
    guard let userRef = try await userRef(email: email) else { throw FetchError.cantLoadEntity }

    try await userRef
      .updateData([
        "invites" : FieldValue.arrayUnion([workspaceId])
      ])
  }

  public func startListenInvites(
    userId: String,
    callback: @escaping ([SUShallowWorkspace]) -> Void
  ) async throws {
    guard let invites = try await userRef(id: userId).getDocument().get("invites") as? [String] else { throw FetchError.cantLoadList }

    guard !invites.isEmpty else {
      callback([])
      return
    }

    let listener = workspaces()
      .whereField("id", in: invites)
      .addSnapshotListener { snapshot, error in
        guard let workspaces = snapshot?.documents else { return }
        Task {
          let result: [SUShallowWorkspace] = await workspaces.asyncCompactMap { workspace in
            
            guard let title = workspace.get("title") as? String else { return nil }
            guard let emoji = workspace.get("emoji") as? String else { return nil }
            guard let documentsCount = workspace.get("documentsCount") as? Int else { return nil }
            guard let membersCount = workspace.get("membersCount") as? Int else { return nil }
            
            return SUShallowWorkspace(
              meta: SUWorkspaceMeta(
                id: workspace.documentID
              ),
              title: title,
              emoji: emoji,
              documentsCount: documentsCount,
              membersCount: membersCount
            )
          }
          callback(result)
        }
      }
    listeners[userId] = listener
  }

  public func confirmInvite(
    userId: String,
    workspaceId: String
  ) {
    let userRef = userRef(id: userId)
    let workspaceRef = workspaceRef(id: workspaceId)
    userRef.updateData([
      "invites" : FieldValue.arrayRemove([workspaceId]),
      "workspaces" : FieldValue.arrayUnion([workspaceId])
    ])
    workspaceRef.updateData([
      "members" : FieldValue.arrayUnion([
        [
          "id" : userId,
          "permission" : 1
        ]
      ]),
      "membersCount": FieldValue.increment(Int64(1))
    ])
  }

  public func rejectInvite(
    userId: String,
    workspaceId: String
  ) {
    let userRef = userRef(id: userId)
    userRef.updateData([
      "invites" : FieldValue.arrayRemove([workspaceId])
    ])
  }

  // MARK: - Document

  public func startListenDocument(
    documentId: String,
    callback: @escaping (SUDocument) -> Void
  ) {
    let listener = documentRef(id: documentId)
      .addSnapshotListener { document, error in
        guard let document = document else { return }

        Task {
          guard let workspaceId = document.get("workspaceId") as? String else { throw FetchError.cantLoadEntity }
          guard let ownerId = document.get("ownerId") as? String else { throw FetchError.cantLoadEntity }
          guard let title = document.get("title") as? String else { throw FetchError.cantLoadEntity }
          guard let emoji = document.get("emoji") as? String else { throw FetchError.cantLoadEntity }
          guard let dateCreated = document.get("dateCreated") as? Timestamp else { throw FetchError.cantLoadEntity }
          guard let dateEdited = document.get("dateEdited") as? Timestamp else { throw FetchError.cantLoadEntity }
          guard let items = document.get("items") as? [String: [String: Any]] else { throw FetchError.cantLoadEntity }

          let blocks: [SUDocumentBlock] = items.compactMap { raw in
            guard let id = raw.value["id"] as? String else { return nil }
            guard let type = raw.value["type"] as? Int else { return nil }
            guard let content = raw.value["content"] as? String else { return nil }
            return SUDocumentBlock(id: id, type: .init(type: type), content: content)
          }

          let document = SUDocument(
            meta: SUDocumentMeta(
              id: documentId,
              workspaceId: workspaceId
            ),
            ownerId: ownerId,
            title: title,
            emoji: emoji,
            dateCreated: dateCreated.dateValue(),
            dateEdited: dateEdited.dateValue(),
            items: blocks
          )
          callback(document)
        }
      }
    listeners[documentId] = listener
  }

  public func createDocument(
    with title: String,
    in workspaceId: String,
    for userId: String
  ) async throws -> String {
    let workspaceRef = workspaceRef(id: workspaceId)
    let documentRef = firestore
      .collection("documents")
      .document()

      try await _ = [
        documentRef.setData([
          "id" : documentRef.documentID,
          "workspaceId" : workspaceId,
          "ownerId" : userId,
          "title" : title,
          "emoji" : "",
          "dateCreated" : Timestamp(date: Date.now),
          "dateEdited" : Timestamp(date: Date.now),
          "items": []
        ]),
        workspaceRef
          .updateData([
            "documents" : FieldValue.arrayUnion([documentRef.documentID]),
            "documentsCount" : FieldValue.increment(Int64(1))
          ])
      ]

    return documentRef.documentID
  }

  public func document(with id: String) async throws -> SUDocument {
    let document = try await documentRef(id: id).getDocument()

    guard let workspaceId = document.get("workspaceId") as? String else { throw FetchError.cantLoadEntity }
    guard let ownerId = document.get("ownerId") as? String else { throw FetchError.cantLoadEntity }
    guard let title = document.get("title") as? String else { throw FetchError.cantLoadEntity }
    guard let emoji = document.get("emoji") as? String else { throw FetchError.cantLoadEntity }
    guard let dateCreated = document.get("dateCreated") as? Timestamp else { throw FetchError.cantLoadEntity }
    guard let dateEdited = document.get("dateEdited") as? Timestamp else { throw FetchError.cantLoadEntity }
    guard let items = document.get("items") as? Array<[String: [String: Any]]> else { throw FetchError.cantLoadEntity }

    let blocks: [SUDocumentBlock] = items.flatMap(\.values).compactMap { raw in
      guard let id = raw["id"] as? String else { return nil }
      guard let type = raw["type"] as? Int else { return nil }
      guard let content = raw["content"] as? String else { return nil }
      return SUDocumentBlock(id: id, type: .init(type: type), content: content)
    }

    return SUDocument(
      meta: SUDocumentMeta(
        id: id,
        workspaceId: workspaceId
      ),
      ownerId: ownerId,
      title: title,
      emoji: emoji,
      dateCreated: dateCreated.dateValue(),
      dateEdited: dateEdited.dateValue(),
      items: blocks
    )
  }

  public func updateDocument(
    documentId: String,
    updateSubject: SUDocumentUpdateSubject
  ) async throws {
    switch updateSubject {
      case .title(let text):
        try await updateDocument(with: documentId, title: text)
      case .emoji(let text):
        try await updateDocument(with: documentId, emoji: text)
      case .block(let block):
        switch block.type {
          case .text:
            try await updateDocument(
              with: documentId,
              textBlockId: block.id,
              text: block.content
            )
          case .image:
            fatalError()
        }
    }
  }

  public func updateDocument(with id: String, title: String) async throws {
    try await documentRef(id: id)
      .updateData([
        "title" : title,
        "dateEdited" : Timestamp(date: Date.now)
      ])
  }

  public func updateDocument(with id: String, emoji: String) async throws {
    try await documentRef(id: id)
      .updateData([
        "emoji" : emoji,
        "dateEdited" : Timestamp(date: Date.now)
      ])
  }

  func updateDocument(
    with id: String,
    textBlockId: String,
    text: String
  ) async throws {
    try await documentRef(id: id)
      .updateData([
        "items.\(textBlockId).content": text
      ])
//    let documentSnapshot = try await document.getDocument()
//    guard let items = document.get("items") as? Array<[String: Any]> else { throw FetchError.cantLoadEntity }
//      .getDocument()
//      .get("items")
    
//      .updateData([
//        "items"
//      ])
  }

  public func updateDocument(with id: String, text: String) async throws {
    try await documentRef(id: id)
      .updateData([
        "text" : text,
        "dateEdited" : Timestamp(date: Date.now)
      ])
  }

  public func deleteDocument(with id: String, in workspaceId: String) async throws {
    let workspaceRef = workspaceRef(id: workspaceId)
    let documentRef = documentRef(id: id)
    
    try await _ = [
      workspaceRef
        .updateData([
          "documents" : FieldValue.arrayRemove([id]),
          "documentsCount" : FieldValue.increment(Int64(-1))
        ]),
      documentRef.delete()
    ]
  }

    // MARK: - User

    public func user(with id: String) async throws -> SUUser {
        let user = try await userRef(id: id).getDocument()

        guard let username = user.get("username") as? String else { throw FetchError.cantLoadEntity }
        guard let email = user.get("email") as? String else { throw FetchError.cantLoadEntity }
        let avatarPath = user.get("avatarPath") as? String

        return SUUser(
            meta: SUUserMeta(
                id: id
            ),
            username: username,
            email: email,
            invites: [],
            avatarPath: avatarPath
        )
    }

    public func updateUser(with id: String, name: String) async throws {
        try await userRef(id: id)
            .updateData([
                "username": name
            ])
    }

    public func startListenUser(
        with id: String,
        callback: @escaping (SUUser) -> Void
    ) {
        let listener = userRef(id: id)
            .addSnapshotListener { snapshot, error in
                guard let username = snapshot?.get("username") as? String else { return }
                guard let email = snapshot?.get("email") as? String else { return }
                let avatarPath = snapshot?.get("avatarPath") as? String
                callback(SUUser(meta: SUUserMeta(id: id), username: username, email: email, invites: [], avatarPath: avatarPath))
            }
        listeners[id] = listener
    }

    public func uploadImage(data: Data, userId: String) {
        let fileRef = storage.reference()
            .child("avatars/\(userId).jpg")
        fileRef.putData(data, metadata: nil) { (metadata, error) in
          guard let metadata = metadata else {
            // Uh-oh, an error occurred!
            return
          }
          // Metadata contains file metadata such as size, content-type.
          let size = metadata.size
          // You can also access to download URL after upload.
          fileRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              // Uh-oh, an error occurred!
              return
            }
              self.userRef(id: userId)
                  .updateData([
                    "avatarPath": downloadURL.absoluteString
                  ])
//              print(downloadURL)
          }
        }.enqueue()
    }

    public func stopListen(with id: String) {
        listeners.removeValue(forKey: id)
    }
}

// MARK: - Search

public extension FireRepository {

    func searchWorkspaces(for userId: String, with name: String) async throws -> [SUShallowWorkspace] {
        return try await workspaces()
            .whereField("ownerId", isEqualTo: userId)
            .whereField("title", isGreaterThanOrEqualTo: name)
            .whereField("title", isLessThan: name.appending("\u{f8ff}"))
            .getDocuments()
            .documents
            .asyncCompactMap { document in
                guard let workspaceId = document.get("id") as? String else { return nil }
                guard let title = document.get("title") as? String else { return nil }
                guard let emoji = document.get("emoji") as? String else { return nil }
                guard let documentsCount = document.get("documentsCount") as? Int else { return nil }
                guard let membersCount = document.get("membersCount") as? Int else { return nil }

                return SUShallowWorkspace(
                    meta: SUWorkspaceMeta(
                        id: workspaceId
                    ),
                    title: title,
                    emoji: emoji,
                    documentsCount: documentsCount,
                    membersCount: membersCount
                )
            }
    }

    func searchDocuments(for userId: String, with name: String) async throws -> [SUShallowDocument] {
        return try await documents()
            .whereField("ownerId", isEqualTo: userId)
            .whereField("title", isGreaterThanOrEqualTo: name)
            .whereField("title", isLessThan: name.appending("\u{f8ff}"))
            .getDocuments()
            .documents
            .asyncCompactMap { document in
                guard let documentId = document.get("id") as? String else { return nil }
                guard let workspaceId = document.get("workspaceId") as? String else { return nil }
                guard let title = document.get("title") as? String else { return nil }
                guard let emoji = document.get("emoji") as? String else { return nil }
                guard let dateCreated = document.get("dateCreated") as? Timestamp else { return nil }

                return SUShallowDocument(
                    meta: SUDocumentMeta(
                        id: documentId,
                        workspaceId: workspaceId
                    ),
                    title: title,
                    emoji: emoji,
                    dateCreated: dateCreated.dateValue()
                )
            }
    }
}
