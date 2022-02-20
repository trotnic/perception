//
//  WorkspaceViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 13.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import Combine
import SUFoundation

public final class WorkspaceViewModel: ObservableObject {

    @Published public private(set) var navigationTitle: String = "Workspace"
    @Published public private(set) var workspaceTitle: String = ""
    @Published public private(set) var membersCount: Int = 0
    @Published public private(set) var viewItems: [ListTileViewItem] = []

    private let appState: SUAppStateProvider
    private let workspaceManager: SUManagerWorkspace
    private let workspaceMeta: SUWorkspaceMeta

    public init(appState: SUAppStateProvider,
                workspaceManager: SUManagerWorkspace,
                workspaceMeta: SUWorkspaceMeta) {
        self.appState = appState
        self.workspaceManager = workspaceManager
        self.workspaceMeta = workspaceMeta
    }
}

// MARK: - Public interface

public extension WorkspaceViewModel {

    func load() {
        Task {
            let workspace = try await workspaceManager.loadWorkspace(id: workspaceMeta.id)
            await MainActor.run {
                workspaceTitle = workspace.title
                viewItems = workspace.documents.map {
                    .init(id: $0.meta.id, iconText: "", title: $0.title)
                }
            }
        }
    }

    func selectItem(with id: String) {
        appState.change(route: .read(.document(SUDocumentMeta(id: id, workspaceId: workspaceMeta.id))))
    }

    func createAction() {
        appState.change(route: .create)
    }

    func backAction() {
        appState.change(route: .back)
    }
}

// MARK: - Private interface

private extension WorkspaceViewModel {
    
}
