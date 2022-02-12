//
//  SpaceManager.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 9.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public final class SpaceManager {

    private let repository: FireRepository

    public init(repository: FireRepository) {
        self.repository = repository
    }
}

// MARK: - Public interface

public extension SpaceManager {

    func loadWorkspaces(for userId: String) async throws -> [SUWorkspace] {
        try await repository.workspaces(for: userId)
//        let result = repository.readWorkspaces()
//        switch result {
//        case .success(let workspaces):
//            return workspaces
//        case .failure(let error):
//            print(error)
//            return []
//        }
    }

    func createWorkspace(name: String, userId: String) async throws -> String {
//        let result = repository.createWorkspace(name: name)
//        switch result {
//        case .success(let identifier):
//            return identifier
//        case .failure(let error):
//            fatalError(error.localizedDescription)
//        }
        try await repository.createWorkspace(with: name, userId: userId)
    }
}

// MARK: - Private interface

private extension SpaceManager {

    
}
