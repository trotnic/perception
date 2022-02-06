//
//  WorkspaceManager.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 9.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public final class WorkspaceManager {

    private let repository: FireRepository

    public init(repository: FireRepository) {
        self.repository = repository
    }
}

public extension WorkspaceManager {

    func loadWorkspace(id: String) async throws -> SUWorkspace {
        try await repository.workspace(with: id)
    }

    func loadShelfs(id: UUID) -> [SUShelf] {
        let result = repository.readShelfs(workspaceId: id)
        switch result {
        case .success(let shelfs):
            return shelfs
        case .failure(let error):
            print(error)
            return []
        }
    }
}
