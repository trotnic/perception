//
//  WorkspaceViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 13.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import Combine

let commonShelfUUID = UUID()

let shelfs: [SUShelf] = [
//    .init(id: commonShelfUUID, workspaceId: commonWorkspaceUUID, title: "Lolkek"),
//    .init(id: .init(), workspaceId: commonWorkspaceUUID, title: "Cheburek"),
//    .init(id: .init(), workspaceId: commonWorkspaceUUID, title: "Ma shelf"),
]

public final class WorkspaceViewModel: ObservableObject {

    @Published public private(set) var navigationTitle: String = "Workspace"
    @Published public private(set) var workspaceTitle: String = ""
    @Published public private(set) var membersCount: Int = 0
    @Published public private(set) var viewItems: [ListTileViewItem] = []
    private var workspaceItem: SUWorkspace!

    private let environment: Environment
    private var spaceManager: SpaceManager {
        environment.spaceManager
    }

    private var state: AppState {
        environment.state
    }

    public init(meta: SUWorkspaceMeta, environment: Environment = .dev) {
        self.environment = environment
    }
}

// MARK: - Public interface

public extension WorkspaceViewModel {

    func loadWorkspaceIfNeeded() {
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

    func selectItem(with id: UUID) {
//        state.change(route: .workspace(.read(id)))
    }

    func createAction() {
//        state.change(route: .workspace(.create))
    }

    func backAction() {
        state.change(route: .back)
    }
}

// MARK: - Private interface

private extension WorkspaceViewModel {
    
}
