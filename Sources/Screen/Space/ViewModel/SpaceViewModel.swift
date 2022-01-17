//
//  SpaceViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 9.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import Combine


final class SpaceViewModel: ObservableObject {

    @Published var items: [SUWorkspace] = []
    private let environment: Environment
    private var spaceManager: SpaceManager {
        environment.spaceManager
    }
    private var state: AppState {
        environment.state
    }

    init(environment: Environment = .dev) {
        self.environment = environment
    }

    func load() {
        let result = LocalRepository.shared.readWorkspaces()
        switch result {
        case .success(let items):
            self.items = items
        case .failure(let error):
            print(error)
        }
    }

    func persist(title: String) {
        let workspaceId = spaceManager.createWorkspace(name: title)
        state.change(route: .workspace(workspaceId))
    }

    func select(item: SUWorkspace) {
        state.change(route: .workspace(item.id))
    }
}
