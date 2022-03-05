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
    @Published public var workspaceTitle: String = ""
    @Published public private(set) var membersCount: Int = 0
    @Published public private(set) var viewItems: [ListTileViewItem] = []

    private let appState: SUAppStateProvider
    private let workspaceManager: SUManagerWorkspace
    private let sessionManager: SUManagerUserIdentifiable
    private let workspaceMeta: SUWorkspaceMeta

    private var disposeBag = Set<AnyCancellable>()

    public init(
        appState: SUAppStateProvider,
        workspaceManager: SUManagerWorkspace,
        sessionManager: SUManagerUserIdentifiable,
        workspaceMeta: SUWorkspaceMeta
    ) {
        self.appState = appState
        self.workspaceManager = workspaceManager
        self.sessionManager = sessionManager
        self.workspaceMeta = workspaceMeta
        setupBindings()
    }
}

// MARK: - Public interface

public extension WorkspaceViewModel {

    func load() {
//        workspaceManager.loadWorkspace(id: workspaceMeta.id)
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

    func deleteAction() {
        Task {
            try await workspaceManager.deleteWorkspace(id: workspaceMeta.id, userId: sessionManager.userId)
            await MainActor.run {
                appState.change(route: .space)
            }
        }
    }
}

// MARK: - Private interface

private extension WorkspaceViewModel {

    func setupBindings() {
        workspaceManager.workspace
            .receive(on: DispatchQueue.main)
            .sink { [self] workspace in
                workspaceTitle = workspace.title
                viewItems = workspace.documents.map {
                    .init(id: $0.meta.id, iconText: "", title: $0.title)
                }
            }
            .store(in: &disposeBag)

        $workspaceTitle
            .debounce(for: 2.0, scheduler: DispatchQueue.main)
            .sink { value in
                
            }
            .store(in: &disposeBag)
    }
}
