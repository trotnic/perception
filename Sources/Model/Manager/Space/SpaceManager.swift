//
//  SpaceManager.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 9.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

final class SpaceManager {

    private let repository: Repository

    init(repository: Repository) {
        self.repository = repository
    }

    func getWorkspaces() -> [SUWorkspace] {
        let result = repository.readWorkspaces()
        switch result {
        case .success(let workspaces):
            return workspaces
        case .failure(let error):
            print(error)
            return []
        }
    }

    func createWorkspace(name: String) -> UUID {
        let result = repository.createWorkspace(name: name)
        switch result {
        case .success(let identifier):
            return identifier
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
}
