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

    @Published public var workspaceTitle: String = .empty
    @Published public var emoji: String = .empty

    @Published public private(set) var membersCount: Int = .zero
    @Published public private(set) var documentsCount: Int = .zero
    @Published public private(set) var viewItems: [ListItem] = []

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

    func loadAction() {
        workspaceManager.observe(workspaceId: workspaceMeta.id)
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

public extension WorkspaceViewModel {

    struct ListItem: Identifiable {
        public let id = UUID()
        public let title: String
        public let emoji: String
        public let action: () -> Void
    }
}

// MARK: - Private interface

private extension WorkspaceViewModel {

    func setupBindings() {
        workspaceManager
            .workspace
            .receive(on: DispatchQueue.main)
            .sink { [self] workspace in
                workspaceTitle = workspace.title
                emoji = workspace.emoji
                membersCount = workspace.members.count
                documentsCount = workspace.documents.count
                viewItems = workspace.documents.map { document in
                    ListItem(
                        title: document.title,
                        emoji: document.emoji,
                        action: {
                            selectItem(with: document.meta.id)
                        }
                    )
                }
            }
            .store(in: &disposeBag)

        $workspaceTitle
            .drop(while: { $0.isEmpty })
            .debounce(for: 1.0, scheduler: DispatchQueue.main)
            .sink { [self] value in
                Task {
                    do {
                        try await workspaceManager.updateWorkspace(id: workspaceMeta.id, title: value)
                    } catch {
                        
                    }
                }
            }
            .store(in: &disposeBag)

        $emoji
            .drop(while: { $0 == self.workspaceManager.workspace.value.emoji })
            .debounce(for: 1.0, scheduler: DispatchQueue.main)
            .sink { [self] value in
                Task {
                    do {
                        try await workspaceManager.updateWorkspace(id: workspaceMeta.id, emoji: value)
                    } catch {
                        
                    }
                }
            }
            .store(in: &disposeBag)
    }

    func selectItem(with id: String) {
        appState.change(route: .read(.document(SUDocumentMeta(id: id, workspaceId: workspaceMeta.id))))
    }
}
