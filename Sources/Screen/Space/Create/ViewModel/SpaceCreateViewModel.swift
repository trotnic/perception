//
//  SpaceCreateViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 13.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import Combine

public final class SpaceCreateViewModel: ObservableObject {

    @Published var workspaceName: String = ""
    private let environment: Environment
    private var state: AppState { environment.state }

    private var spaceManager: SpaceManager { environment.spaceManager }
    private var userSession: UserSession { environment.userSession }

    public init(environment: Environment = .dev) {
        self.environment = environment
    }
}

// MARK: - Public interface

public extension SpaceCreateViewModel {

    func createWorkspace() {
        Task {
            let workspaceId = try await spaceManager.createWorkspace(name: workspaceName, userId: userSession.userId!)
            await MainActor.run {
                state.change(route: .read(.workspace(SUWorkspaceMeta(id: workspaceId))))
            }
        }
    }

    func backAction() {
        state.change(route: .back)
    }
}

// MARK: - Private interface

private extension SpaceCreateViewModel {
    
}
