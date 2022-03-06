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
    - id
    - documents
    - title
    - owner
    - members

Document:
    - id
    - workspaceId
    - title
    - text
    - linked
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
        guard let workspaces = try await userRef(id: userId).getDocument().get("workspaces") as? Array<DocumentReference> else { throw FetchError.cantLoadList }

        let result: [SUShallowWorkspace] = try await workspaces.asyncCompactMap { document in
            let document = try await document.getDocument()
            guard let workspaceId = document.get("id") as? String else { return nil }
            guard let title = document.get("title") as? String else { return nil }

            return SUShallowWorkspace(meta: .init(id: workspaceId), title: title)
        }
        return result
    }

    // MARK: - Workspace

    public func createWorkspace(with title: String, userId: String) async throws -> String {
        let workspaceRef = workspaces()
            .document()
        let userRef = userRef(id: userId)
        try await _ = [
            workspaceRef.setData([
                "id" : workspaceRef.documentID,
                "ownerId" : userId,
                "title" : title,
                "members" : [],
                "documents" : []
            ]),
            userRef
                .updateData([
                    "workspaces" : FieldValue.arrayUnion([workspaceRef])
                ])
        ]
        return workspaceRef.documentID
    }

    public func workspace(with id: String) async throws -> SUWorkspace {
        let workspaceSnapshot = try await workspaceRef(id: id).getDocument()

        guard let title = workspaceSnapshot.get("title") as? String else { throw FetchError.cantCreate }
        guard let documents = workspaceSnapshot.get("documents") as? Array<String> else { throw FetchError.cantCreate }

        let shallowDocuments: [SUShallowDocument] = try await documents.asyncCompactMap { documentId in
            let document = try await documentRef(id: documentId).getDocument()
            guard let title = document.get("title") as? String else { return nil }
            return SUShallowDocument(meta: SUDocumentMeta(id: document.documentID, workspaceId: id), title: title)
        }
        return SUWorkspace(meta: SUWorkspaceMeta(id: id), title: title, documents: shallowDocuments)
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

    public func updateWorkspace(id: String, title: String) async throws {
        
    }

    public func deleteWorkspace(id: String, userId: String) async throws {
        let userRef = userRef(id: userId)
        let workspaceRef = workspaceRef(id: id)

        try await _ = [
            userRef
                .updateData([
                    "workspaces" : FieldValue.arrayRemove([workspaceRef])
                ]),
            firestore
                .collection("documents")
                .whereField("workspace", isEqualTo: workspaceRef)
                .getDocuments()
                .documents
                .forEach { $0.reference.delete() },
            workspaceRef.delete()
        ]
    }

    // MARK: - Document

    public func createDocument(with title: String,
                               in workspaceId: String,
                               for userId: String) async throws -> String {
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
                "linked" : []
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

        guard let title = document.get("title") as? String else { throw FetchError.cantLoadEntity }
        guard let text = document.get("text") as? String else { throw FetchError.cantLoadEntity }
        guard let workspaceId = document.get("workspaceId") as? String else { throw FetchError.cantLoadEntity }

        return SUDocument(meta: .init(id: id, workspaceId: workspaceId), title: title, text: text)
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
                    "documents" : FieldValue.arrayRemove([documentRef])
                ]),
            documentRef.delete()
        ]
    }

    public func user(with id: String) async throws -> SUUser {
        let user = try await userRef(id: id).getDocument()

        guard let username = user.get("username") as? String else { throw FetchError.cantLoadEntity }
        guard let email = user.get("email") as? String else { throw FetchError.cantLoadEntity }

        return SUUser(meta: .init(id: id), username: username, email: email)
    }

    public func updateUser(with id: String, name: String) async throws {
        try await userRef(id: id)
            .updateData([
                "username": name
            ])
    }

    public func startListenUser(with id: String, callback: @escaping (SUUser) -> Void) {
        let listener = userRef(id: id)
            .addSnapshotListener { snapshot, error in
                guard let username = snapshot?.get("username") as? String else { return }
                guard let email = snapshot?.get("email") as? String else { return }
                callback(SUUser(meta: SUUserMeta(id: id), username: username, email: email))
            }
        listeners[id] = listener
    }

    public func stopListen(with id: String) {
        listeners[id] = nil
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

                return SUShallowWorkspace(meta: .init(id: workspaceId), title: title)
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

                return SUShallowDocument(meta: .init(id: documentId, workspaceId: workspaceId), title: title)
            }
    }
}
