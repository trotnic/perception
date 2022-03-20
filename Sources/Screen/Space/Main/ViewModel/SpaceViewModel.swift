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
    @Published public private(set) var isSpaceEmpty: Bool = false

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

    func loadAction() {
        spaceManager.observe(for: sessionManager.userId)
    }

    func createAction() {
        appState.change(route: .create)
    }
}

public extension SpaceViewModel {

    struct ListItem: Identifiable {
        public let id = UUID()
        public let index: Int
        public let title: String
        public let emoji: String
        public let badges: [Badge]
        public let action: () -> Void
    }

    struct Badge {
        public enum BadgeType {
            case members
            case dateCreated
            case documents
        }

        public let title: String
        public let type: BadgeType
    }
}

// MARK: - Private interface

private extension SpaceViewModel {

    func setupBindings() {
        spaceManager
            .workspaces
            .receive(on: DispatchQueue.main)
            .map { workspaces in
                workspaces.enumerated().map { item in
                    ListItem(
                        index: item.offset,
                        title: item.element.title,
                        emoji: item.element.emoji,
                        badges: [
                            Badge(title: "\(item.element.membersCount) members", type: .members),
                            Badge(title: "\(item.element.documentsCount) documents", type: .documents)
                        ],
                        action: { self.selectItem(with: item.element.meta.id) }
                    )
                }
            }
            .assign(to: &$items)

        $items
            .map(\.isEmpty)
            .removeDuplicates()
            .assign(to: &$isSpaceEmpty)
    }

    func selectItem(with id: String) {
        appState.change(route: .read(.workspace(SUWorkspaceMeta(id: id))))
    }
}
