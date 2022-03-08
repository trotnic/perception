//
//  SpaceManager.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 9.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine
import Foundation

public final class SpaceManager: SUManagerSpace {

    public private(set) var workspaces = CurrentValueSubject<[SUShallowWorkspace], Never>([])

    private let repository: Repository

    public init(
        repository: Repository
    ) {
        self.repository = repository
    }
}

// MARK: - Public interface

public extension SpaceManager {

    func observe(for userId: String) {
        repository
            .startListenSpace(userId: userId) { workspaces in
                self.workspaces.value = workspaces
            }
    }

    func loadWorkspaces(for userId: String) async throws -> [SUShallowWorkspace] {
        try await repository.workspaces(for: userId)
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
