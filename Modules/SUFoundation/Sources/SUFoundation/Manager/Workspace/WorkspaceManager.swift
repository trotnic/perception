//
//  WorkspaceManager.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 9.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public final class WorkspaceManager: SUManagerWorkspace {

    private let repository: Repository

    public init(repository: Repository) {
        self.repository = repository
    }
}

public extension WorkspaceManager {

    func loadWorkspace(id: String) async throws -> SUWorkspace {
        try await repository.workspace(with: id)
    }

    func createDocument(title: String, workspaceId: String, userId: String) async throws -> String {
        try await repository.createDocument(with: title, in: workspaceId, for: userId)
    }
}
