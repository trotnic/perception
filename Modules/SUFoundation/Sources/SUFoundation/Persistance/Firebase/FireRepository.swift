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
}

extension FireRepository: Repository {

    // MARK: - Space

    public func workspaces(for userId: String) async throws -> [SUShallowWorkspace] {
        guard
            let data = try await firestore
                .collection("users")
                .document(userId)
                .getDocument()
                .data(),
            let workspaces = data["workspaces"] as? Array<DocumentReference>
        else {
            throw FetchError.cantLoadList
        }

        let result: [SUShallowWorkspace] = try await workspaces.asyncCompactMap { document in
            guard let data = try await document.getDocument().data() else {
                return nil
            }
            let workspaceId = data["id"] as! String
            let title = data["title"] as! String
//            let documents: [SUShallowDocument] = try await (data["documents"] as! Array<DocumentReference>).asyncMap { docRef in
//                let doc = try await docRef.getDocument()
//                let title = doc.data()?["title"] as! String
//                return SUShallowDocument(meta: SUDocumentMeta(id: doc.documentID, workspaceId: workspaceId), title: title)
//            }
            let workspace = SUShallowWorkspace(meta: .init(id: workspaceId), title: title)
            return workspace
        }
        return result
    }

    // MARK: - Workspace

    public func listenWorkspace(with id: String, completion: @escaping (SUWorkspace) -> Void) {
        let listener = firestore
            .collection("workspaces")
            .document(id)
            .addSnapshotListener { snapshot, error in
                Task {
                    guard let data = snapshot?.data() else { return }
                    guard let title = data["title"] as? String else { return }
                    guard let rawDocuments = data["documents"] as? Array<DocumentReference> else { return }
                    let documents: [SUShallowDocument] = try await rawDocuments.asyncCompactMap { docRef in
                        let doc = try await docRef.getDocument()
                        guard let title = doc.data()?["title"] as? String else { return nil }
                        return SUShallowDocument(meta: SUDocumentMeta(id: doc.documentID, workspaceId: id), title: title)
                    }
                    completion(SUWorkspace(meta: SUWorkspaceMeta(id: id), title: title, documents: documents))
                }
            }
        listeners[id] = listener
    }

    public func workspace(with id: String) async throws -> SUWorkspace {
        guard
            let data = try await firestore
                .collection("workspaces")
                .document(id)
                .getDocument().data()
        else {
            throw FetchError.cantLoadEntity
        }
        let title = data["title"] as! String
        let documents: [SUShallowDocument] = try await (data["documents"] as! Array<DocumentReference>).asyncMap { docRef in
            let doc = try await docRef.getDocument()
            let title = doc.data()?["title"] as! String
            return SUShallowDocument(meta: SUDocumentMeta(id: doc.documentID, workspaceId: id), title: title)
        }
        return SUWorkspace(meta: SUWorkspaceMeta(id: id), title: title, documents: documents)
    }

    public func createWorkspace(with title: String,
                                userId: String) async throws -> String {
        let ref = firestore
            .collection("workspaces")
            .document()
        try await ref.setData([
            "id" : ref.documentID,
            "owner" : firestore.collection("users").document(userId),
            "title" : title,
            "members" : []
        ])
        let user = firestore
            .collection("users")
            .document(userId)
        guard
            let workspaces = try await user.getDocument().data()?["workspaces"] as? Array<DocumentReference>
        else {
            throw FetchError.cantCreate
        }
        try await user.updateData([
            "workspaces" : workspaces + [ref]
        ])
        return ref.documentID
    }

    // MARK: - Document

    public func createDocument(with title: String,
                               in workspaceId: String,
                               for userId: String) async throws -> String {
        let ref = firestore
            .collection("documents")
            .document()
        try await ref.setData([
            "id" : ref.documentID,
            "title" : title,
            "workspaceId" : workspaceId,
            "linked" : [],
            "parts" : [],
            "text" : ""
        ])
        let workspaceRef = firestore
            .collection("workspaces")
            .document(workspaceId)
        guard let documents = try await workspaceRef.getDocument().data()?["documents"] as? Array<DocumentReference>
        else {
            throw FetchError.cantCreate
        }
        try await workspaceRef.updateData([
            "documents" : documents + [ref]
        ])
        return ref.documentID
    }

    public func document(with id: String) async throws -> SUDocument {
        guard
            let data = try await firestore
                .collection("documents")
                .document(id)
                .getDocument()
                .data()
        else {
            throw FetchError.cantLoadEntity
        }

        
        let title = data["title"] as! String
        let text = data["text"] as! String
        let workspaceId = data["workspaceId"] as! String
        return SUDocument(meta: .init(id: id, workspaceId: workspaceId), title: title, text: text)
    }

    public func observeDocument(with id: String) {
        firestore
            .collection("documents")
            .document(id)
            .addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else { return }
                guard let data = snapshot.data() else { return }
                print(data["text"])
            }
    }

    public func updateDocument(with id: String, text: String) async throws {
        try await firestore
            .collection("documents")
            .document(id)
            .updateData([
                "text" : text
            ])
    }

    public func deleteDocument(with id: String, in workspaceId: String) async throws {
        let workspaceRef = firestore
            .collection("workspaces")
            .document(workspaceId)
        
        let documentRef = firestore
            .collection("documents")
            .document(id)
        
        try await workspaceRef
            .updateData([
                "documents" : FieldValue.arrayRemove([documentRef])
            ])
        
        try await documentRef.delete()
    }
}
