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

    public init(firestore: Firestore) {
        self.firestore = firestore
    }
}

extension FireRepository: Repository {
    
    public func workspaces(for userId: String) async throws -> [SUWorkspace] {
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

        let result: [SUWorkspace] = try await workspaces.asyncCompactMap { document in
            guard let data = try await document.getDocument().data() else {
                return nil
            }
            let workspaceId = data["id"] as! String
            let title = data["title"] as! String
            let documents: [SUShallowDocument] = try await (data["documents"] as! Array<DocumentReference>).asyncMap { docRef in
                let doc = try await docRef.getDocument()
                let title = doc.data()?["title"] as! String
                return SUShallowDocument(meta: SUDocumentMeta(id: doc.documentID, workspaceId: workspaceId), title: title)
            }
            let workspace = SUWorkspace(meta: .init(id: workspaceId), title: title, documents: documents)
            return workspace
        }
        return result
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
}
