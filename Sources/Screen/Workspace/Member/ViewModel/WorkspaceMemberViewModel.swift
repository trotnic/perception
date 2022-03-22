//
//  WorkspaceMemberViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 7.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine
import Foundation
import SUFoundation

public final class WorkspaceMemberViewModel: ObservableObject {

    @Published public private(set) var items: [ListItem] = []

    private let appState: SUAppStateProvider
    private let memberManager: SUManagerMember
    private let workspaceMeta: SUWorkspaceMeta

    public init(
        appState: SUAppStateProvider,
        memberManager: SUManagerMember,
        workspaceMeta: SUWorkspaceMeta
    ) {
        self.appState = appState
        self.memberManager = memberManager
        self.workspaceMeta = workspaceMeta

        setupBindings()
    }
}

public extension WorkspaceMemberViewModel {

    func load() {
        Task {
            memberManager.members(id: workspaceMeta.id)
        }
    }

    func backAction() {
        appState.change(route: .back)
    }

    func inviteAction() {
        appState.change(route: .invite(workspaceMeta))
    }
}

public extension WorkspaceMemberViewModel {

    struct ListItem: Identifiable {
        public let id = UUID()
        public let index: Int
        public let title: String
        public let imagePath: String?
        public let badges: [Badge]
    }

    struct Badge: Identifiable {

        public enum BadgeType {
            case role
            case permission
        }

        public let id = UUID()
        public let title: String
        public let type: BadgeType
    }
}

private extension WorkspaceMemberViewModel {

    func setupBindings() {
        memberManager
            .members
            .receive(on: DispatchQueue.main)
            .map { items in
                items.enumerated().map { item in
                    ListItem(
                        index: item.offset,
                        title: item.element.user.username,
                        imagePath: item.element.user.avatarPath,
                        badges: [
                            Badge(
                                title: item.element.user.email,
                                type: .role
                            ),
                            Badge(
                                title: item.element.permission.title,
                                type: .permission
                            )
                        ]
                    )
                }
            }
            .assign(to: &$items)
    }
}
