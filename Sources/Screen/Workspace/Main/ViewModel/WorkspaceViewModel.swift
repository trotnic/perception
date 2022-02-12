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

    private let workspaceMeta: SUWorkspaceMeta

    private var workspaceItem: SUWorkspace!

    private let environment: Environment
    private var workspaceManager: WorkspaceManager {
        environment.workspaceManager
    }

    private var state: AppState {
        environment.state
    }

    public init(meta: SUWorkspaceMeta, environment: Environment = .dev) {
        self.environment = environment
        workspaceMeta = meta
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
                    .init(iconText: "", title: $0.title)
                }
            }
        }
    }

    func selectItem(with id: String) {
        state.change(route: .read(.document(SUDocumentMeta(id: id, workspaceId: workspaceMeta.id))))
    }

    func createAction() {
        state.change(route: .create)
    }

    func backAction() {
        state.change(route: .back)
    }
}

// MARK: - Private interface

private extension WorkspaceViewModel {
    
}
