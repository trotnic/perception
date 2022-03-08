//
//  SpaceViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 9.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine
import Foundation
import SUFoundation

public final class SpaceViewModel: ObservableObject {

    @Published public private(set) var items: [ListItem] = []

    private var disposeBag = Set<AnyCancellable>()

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

        setupBindings()
    }
}

// MARK: - Public interface

public extension SpaceViewModel {

    func load() {
        spaceManager.observe(for: sessionManager.userId)
    }

    func createAction() {
        appState.change(route: .create)
    }
}

public extension SpaceViewModel {

    struct ListItem: Identifiable {
        public let id = UUID()
        public let title: String
        public let emoji: String
        public let action: () -> Void
    }
}

// MARK: - Private interface

private extension SpaceViewModel {

    func setupBindings() {
        spaceManager
            .workspaces
            .receive(on: DispatchQueue.main)
            .map { workspaces in
                workspaces.map { workspace in
                    ListItem(
                        title: workspace.title,
                        emoji: workspace.emoji,
                        action: { self.selectItem(with: workspace.meta.id) }
                    )
                }
            }
            .assign(to: &$items)
    }

    func selectItem(with id: String) {
        appState.change(route: .read(.workspace(SUWorkspaceMeta(id: id))))
    }
}
