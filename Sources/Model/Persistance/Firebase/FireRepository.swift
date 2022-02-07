//
//  FireRepository.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 30.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import Combine
import FirebaseStorage
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

extension Sequence {
    func asyncForEach(
        _ operation: (Element) async throws -> Void
    ) async rethrows {
        for element in self {
            try await operation(element)
        }
    }

    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()
        
        for element in self {
            try await values.append(transform(element))
        }
        
        return values
    }
}

public final class FireRepository {

    private let store = Firestore.firestore()
    private let group = DispatchGroup()
}

public extension FireRepository {
    
    func workspaces(for userId: String) async throws -> [SUWorkspace] {
        guard let data = try await store
                .collection("users")
                .document(userId)
                .getDocument().data()?["workspaces"] as? Array<DocumentReference>
        else {
            #warning("provide error")
            throw NSError()
        }

        let result: [SUWorkspace] = try await data.asyncMap { document in
            let data = try await document.getDocument().data()!
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

    func workspace(with id: String) async throws -> SUWorkspace {
        guard let data = try await store
                .collection("workspaces")
                .document(id)
                .getDocument().data()
        else {
            #warning("provide error")
            throw NSError()
        }
        let title = data["title"] as! String
        let documents: [SUShallowDocument] = try await (data["documents"] as! Array<DocumentReference>).asyncMap { docRef in
            let doc = try await docRef.getDocument()
            let title = doc.data()?["title"] as! String
            return SUShallowDocument(meta: SUDocumentMeta(id: doc.documentID, workspaceId: id), title: title)
        }
        return SUWorkspace(meta: SUWorkspaceMeta(id: id), title: title, documents: documents)
    }

    func createWorkspace(with title: String, userId: String) async throws -> String {
        let ref = store
            .collection("workspaces")
            .document()
        try await ref.setData([
            "id" : ref.documentID,
            "owner" : store.collection("users").document(userId),
            "title" : title,
            "members" : []
        ])
        let user = store
            .collection("users")
            .document(userId)
        guard let workspaces = try await user.getDocument().data()?["workspaces"] as? Array<DocumentReference>
        else {
            #warning("provide error")
            throw NSError()
        }
        try await user.updateData([
            "workspaces" : workspaces + [ref]
        ])
        return ref.documentID
    }

    func createDocument(with title: String, in workspaceId: String, for userId: String) async throws -> String {
        let ref = store
            .collection("documents")
            .document()
        try await ref.setData([
            "id" : ref.documentID,
            "title" : title,
            "workspaceId" : workspaceId,
            "linked" : [],
            "parts" : []
        ])
        let workspaceRef = store
            .collection("workspaces")
            .document(workspaceId)
        guard let documents = try await workspaceRef.getDocument().data()?["documents"] as? Array<DocumentReference>
        else {
            #warning("provide error")
            throw NSError()
        }
        try await workspaceRef.updateData([
            "documents" : documents + [ref]
        ])
        return ref.documentID
    }
}
