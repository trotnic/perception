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

    func userRef(id: String) -> DocumentReference {
        firestore
            .collection("users")
            .document(id)
    }

    func workspaceRef(id: String) -> DocumentReference {
        firestore
            .collection("workspaces")
            .document(id)
    }

    func documentRef(id: String) -> DocumentReference {
        firestore
            .collection("documents")
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
        let workspaceRef = firestore
            .collection("workspaces")
            .document()
        let userRef = userRef(id: userId)
        try await _ = [
            workspaceRef.setData([
                "id" : workspaceRef.documentID,
                "owner" : userRef,
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
        guard let documents = workspaceSnapshot.get("documents") as? Array<DocumentReference> else { throw FetchError.cantCreate }

        let shallowDocuments: [SUShallowDocument] = try await documents.asyncCompactMap { document in
            let document = try await document.getDocument()
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
                "title" : title,
                "workspace" : workspaceRef,
                "text" : "",
                "linked" : []
            ]),
            workspaceRef
                .updateData([
                    "documents" : FieldValue.arrayUnion([documentRef])
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
}
