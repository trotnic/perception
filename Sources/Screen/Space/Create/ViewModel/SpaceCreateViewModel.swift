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
    private let sessionManager: SUManagerUserIdentifiable

    public init(
        appState: SUAppStateProvider,
        spaceManager: SUManagerSpace,
        sessionManager: SUManagerUserIdentifiable
    ) {
        self.appState = appState
        self.spaceManager = spaceManager
        self.sessionManager = sessionManager
    }
}

// MARK: - Public interface

public extension SpaceCreateViewModel {

    func createWorkspace() {
        Task {
            let workspaceId = try await spaceManager.createWorkspace(name: workspaceName, userId: sessionManager.userId)
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
