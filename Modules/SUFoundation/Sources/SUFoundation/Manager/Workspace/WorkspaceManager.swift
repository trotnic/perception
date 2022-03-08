//
//  WorkspaceManager.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 9.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine
import Foundation

public final class WorkspaceManager: SUManagerWorkspace {

    public private(set) var workspace = CurrentValueSubject<SUWorkspace, Never>(.empty)

    private let repository: Repository

    public init(
        repository: Repository
    ) {
        self.repository = repository
    }
}

public extension WorkspaceManager {

    func observe(workspaceId: String) {
        repository
            .startListenWorkspace(workspaceId: workspaceId) { workspace in
                self.workspace.value = workspace
            }
    }

    func loadWorkspace(id: String) async throws -> SUWorkspace {
        try await repository.workspace(with: id)
    }

    func createDocument(title: String, workspaceId: String, userId: String) async throws -> String {
        try await repository.createDocument(with: title, in: workspaceId, for: userId)
    }

    func updateWorkspace(id: String, title: String) async throws {
        try await repository.updateWorkspace(id: id, title: title)
    }

    func updateWorkspace(id: String, emoji: String) async throws {
        try await repository.updateWorkspace(id: id, emoji: emoji)
    }

    func deleteWorkspace(id: String, userId: String) async throws {
        try await repository.deleteWorkspace(id: id, userId: userId)
    }
}
