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
        else { throw NSError() }

        let result: [SUWorkspace?] = try await data.asyncMap { document in
            let doc = try await document.getDocument()
            let workspace: SUWorkspace? = doc.data().flatMap { data in
                let id = data["id"] as! String
                let title = data["title"] as! String
                let workspace = SUWorkspace(meta: .init(id: id), title: title, shelfs: [])
                return workspace
            }
            return workspace
        }
        return result.compactMap { $0 }
    }

    func workspace(with id: String) async throws -> SUWorkspace {
        guard let data = try await store
                .collection("workspaces")
                .document(id)
                .getDocument().data()
        else { throw NSError() }
        let id = data["id"] as! String
        let title = data["title"] as! String
        return SUWorkspace(meta: SUWorkspaceMeta(id: id), title: title, shelfs: [])
    }

    func createWorkspace(with title: String, userId: String) async throws -> String {
        let ref = store
            .collection("workspaces")
            .document()
        try await ref.setData([
            "id" : ref.documentID,
            "owner" : store.collection("users").document(userId),
            "title" : title,
            "shelfs" : [],
            "members" : []
        ])
        let user = store
            .collection("users")
            .document(userId)
        guard let workspaces = try await user.getDocument().data()?["workspaces"] as? Array<DocumentReference>
        else {
            throw NSError()
        }
        try await user.updateData([
            "workspaces" : workspaces + [ref]
        ])
        return ref.documentID
    }
    
    func readShelfs(workspaceId: UUID) -> Result<[SUShelf], Error> {
        .success([])
    }
}
