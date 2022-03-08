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
 */

public final class FireRepository {

    enum FetchError: Error {
        case cantLoadList
        case cantLoadEntity
        case cantCreate
    }

    private let firestore: Firestore
    private var listeners: [String : ListenerRegistration] = [:]

    public init(firestore: Firestore) {
        self.firestore = firestore
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

            return SUShallowWorkspace(
                meta: SUWorkspaceMeta(
                    id: workspaceId
                ),
                title: title,
                emoji: emoji
            )
        }
        return result
    }

    public func startListenSpace(
        userId: String,
        callback: @escaping ([SUShallowWorkspace]) -> Void
    ) {
        let listener = workspaces()
            .whereField("ownerId", isEqualTo: userId)
            .addSnapshotListener { snapshot, error in
                guard let workspaces = snapshot?.documents else { return }
                Task {
                    let result: [SUShallowWorkspace] = await workspaces.asyncCompactMap { workspace in

                        guard let title = workspace.get("title") as? String else { return nil }
                        guard let emoji = workspace.get("emoji") as? String else { return nil }

                        return SUShallowWorkspace(
                            meta: SUWorkspaceMeta(
                                id: workspace.documentID
                            ),
                            title: title,
                            emoji: emoji
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
                    "emoji" : "🔥"
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
                        
                        let shallowDocuments: [SUShallowDocument] = try await documents.asyncCompactMap { documentId in
                            let document = try await documentRef(id: documentId).getDocument()
                            
                            guard let title = document.get("title") as? String else { return nil }
                            guard let emoji = document.get("emoji") as? String else { return nil }
                            
                            return SUShallowDocument(
                                meta: SUDocumentMeta(
                                    id: documentId,
                                    workspaceId: workspaceId
                                ),
                                title: title,
                                emoji: emoji
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
                            emoji: emoji
                        )
                        callback(workspace)
                    } catch {
                        
                    }
                }
            }
        listeners[workspaceId] = listener
    }

    //    public func listenWorkspace(with id: String, completion: @escaping (SUWorkspace) -> Void) {
    //        let listener = workspaceRef(id: id)
    //            .addSnapshotListener { snapshot, error in
    //                Task {
    //                    guard let data = snapshot?.data() else { return }
    //                    guard let title = data["title"] as? String else { return }
    //                    guard let rawDocuments = data["documents"] as? Array<DocumentReference> else { return }
    //                    let documents: [SUShallowDocument] = try await rawDocuments.asyncCompactMap { docRef in
    //                        let doc = try await docRef.getDocument()
    //                        guard let title = doc.data()?["title"] as? String else { return nil }
    //                        return SUShallowDocument(meta: SUDocumentMeta(id: doc.documentID, workspaceId: id), title: title)
    //                    }
    //                    completion(SUWorkspace(meta: SUWorkspaceMeta(id: id), title: title, documents: documents))
    //                }
    //            }
    //        listeners[id] = listener
    //    }

    public func workspace(with id: String) async throws -> SUWorkspace {
        let workspaceSnapshot = try await workspaceRef(id: id).getDocument()

        guard let ownerId = workspaceSnapshot.get("ownerId") as? String else { throw FetchError.cantLoadEntity }
        guard let documents = workspaceSnapshot.get("documents") as? Array<String> else { throw FetchError.cantLoadEntity }
        guard let members = workspaceSnapshot.get("members") as? Array<[String: Any]> else { throw FetchError.cantLoadEntity }
        guard let title = workspaceSnapshot.get("title") as? String else { throw FetchError.cantLoadEntity }
        guard let emoji = workspaceSnapshot.get("emoji") as? String else { throw FetchError.cantLoadEntity }

        let shallowDocuments: [SUShallowDocument] = try await documents.asyncCompactMap { documentId in
            let document = try await documentRef(id: documentId).getDocument()

            guard let title = document.get("title") as? String else { return nil }
            guard let emoji = document.get("emoji") as? String else { return nil }

            return SUShallowDocument(
                meta: SUDocumentMeta(
                    id: documentId,
                    workspaceId: id
                ),
                title: title,
                emoji: emoji
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
            emoji: emoji
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

                            return SUWorkspaceMember(
                                user: SUUser(
                                    meta: SUUserMeta(
                                        id: id
                                    ),
                                    username: username,
                                    email: email
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

    // MARK: - Document

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
                "text" : "",
                "emoji" : "📄"
            ]),
            workspaceRef
                .updateData([
                    "documents" : FieldValue.arrayUnion([documentRef.documentID])
                ])
        ]

        return documentRef.documentID
    }

    public func document(with id: String) async throws -> SUDocument {
        let document = try await documentRef(id: id).getDocument()

        guard let workspaceId = document.get("workspaceId") as? String else { throw FetchError.cantLoadEntity }
        guard let ownerId = document.get("ownerId") as? String else { throw FetchError.cantLoadEntity }
        guard let title = document.get("title") as? String else { throw FetchError.cantLoadEntity }
        guard let text = document.get("text") as? String else { throw FetchError.cantLoadEntity }
        guard let emoji = document.get("emoji") as? String else { throw FetchError.cantLoadEntity }

        return SUDocument(
            meta: SUDocumentMeta(
                id: id,
                workspaceId: workspaceId
            ),
            ownerId: ownerId,
            title: title,
            text: text,
            emoji: emoji
        )
    }

//    public func observeDocument(with id: String) {
//        documentRef(id: id)
//            .addSnapshotListener { snapshot, error in
//                guard let snapshot = snapshot else { return }
//                guard let data = snapshot.data() else { return }
//            }
//    }

    public func updateDocument(with id: String, text: String) async throws {
        try await documentRef(id: id)
            .updateData([
                "text" : text
            ])
    }

    public func deleteDocument(with id: String, in workspaceId: String) async throws {
        let workspaceRef = workspaceRef(id: workspaceId)
        let documentRef = documentRef(id: id)

        try await _ = [
            workspaceRef
                .updateData([
                    "documents" : FieldValue.arrayRemove([id])
                ]),
            documentRef.delete()
        ]
    }

    // MARK: - User

    public func user(with id: String) async throws -> SUUser {
        let user = try await userRef(id: id).getDocument()

        guard let username = user.get("username") as? String else { throw FetchError.cantLoadEntity }
        guard let email = user.get("email") as? String else { throw FetchError.cantLoadEntity }

        return SUUser(
            meta: SUUserMeta(
                id: id
            ),
            username: username,
            email: email
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
                callback(SUUser(meta: SUUserMeta(id: id), username: username, email: email))
            }
        listeners[id] = listener
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

                return SUShallowWorkspace(
                    meta: SUWorkspaceMeta(
                        id: workspaceId
                    ),
                    title: title,
                    emoji: emoji
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

                return SUShallowDocument(
                    meta: SUDocumentMeta(
                        id: documentId,
                        workspaceId: workspaceId
                    ),
                    title: title,
                    emoji: emoji
                )
            }
    }
}
