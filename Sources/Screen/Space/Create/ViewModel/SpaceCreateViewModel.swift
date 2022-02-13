//
//  SpaceCreateViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 13.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import Combine
import SUFoundation

public final class SpaceCreateViewModel: ObservableObject {

    @Published var workspaceName: String = ""

    private let appState: SUAppStateProvider
    private let spaceManager: SUManagerSpace
    private let userManager: SUManagerUser

    public init(appState: SUAppStateProvider,
                spaceManager: SUManagerSpace,
                userManager: SUManagerUser) {
        self.appState = appState
        self.spaceManager = spaceManager
        self.userManager = userManager
    }
}

// MARK: - Public interface

public extension SpaceCreateViewModel {

    func createWorkspace() {
        Task {
            let workspaceId = try await spaceManager.createWorkspace(name: workspaceName, userId: userManager.userId)
            await MainActor.run {
                appState.change(route: .read(.workspace(SUWorkspaceMeta(id: workspaceId))))
            }
        }
    }

    func backAction() {
        appState.change(route: .back)
    }
}

// MARK: - Private interface

private extension SpaceCreateViewModel {
    
}
