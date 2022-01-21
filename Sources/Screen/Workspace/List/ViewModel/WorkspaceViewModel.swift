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
    .init(id: commonShelfUUID, workspaceId: commonWorkspaceUUID, title: "Lolkek", dateCreated: .now),
    .init(id: .init(), workspaceId: commonWorkspaceUUID, title: "Cheburek", dateCreated: .now),
    .init(id: .init(), workspaceId: commonWorkspaceUUID, title: "Ma shelf", dateCreated: .now),
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

    public init(environment: Environment = .dev) {
        self.environment = environment
    }
}

// MARK: - Public interface

public extension WorkspaceViewModel {

    func loadWorkspaceIfNeeded() {
        guard case .workspace(let id) = state.currentSelection else {
            return
        }
        workspaceItem = workspaces.first(where: { $0.id == id })
        viewItems = shelfs.filter { $0.workspaceId == id }.map { item in
            let viewItem = ListTileViewItem(
                id: item.id,
                iconText: "",
                title: item.title
//                membersTitle: "",
//                lastEditTitle: item.dateCreated.debugDescription
            )
            return viewItem
        }
        workspaceTitle = workspaceItem.title
        membersCount = workspaceItem.membersCount
    }

    func selectItem(with id: UUID) {
        state.change(route: .shelf(id))
    }
}

// MARK: - Private interface

private extension WorkspaceViewModel {
    
}
