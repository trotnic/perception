//
//  WorkspaceViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 13.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import Combine

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
            }
        }
//        viewItems = workspaceManager
//            .loadShelfs(id: workspaceMeta.id)
//            .map { shelf in
//                ListTileViewItem(id: shelf.id.uuidString, iconText: "🔥", title: shelf.title)
//            }
//        let workspace = workspaceManager.loadWorkspace(id: workspaceMeta.id)
//        workspaceTitle = workspace.title
//        guard let id = state.currentSelection else {
//            return
//        }
//        workspaceItem = workspaces.first(where: { $0.meta.id == id })
//        viewItems = shelfs.filter { $0.meta.workspaceId == id }.map { item in
//            let viewItem = ListTileViewItem(
//                id: item.meta.id,
//                iconText: "",
//                title: item.title
//            )
//            return viewItem
//        }
//        workspaceTitle = workspaceItem.title
    }

    func selectItem(with id: String) {
//        state.change(route: .workspace(.read(id)))
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
