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

    @Published public private(set) var content: [Content] = []

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

    struct Content: Identifiable {
        public let id = UUID()
        public let title: String
        public let badges: [Badge]

        public init(
            title: String,
            badges: [Badge]
        ) {
            self.title = title
            self.badges = badges
        }
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
                items.map { item in
                    Content(
                        title: item.user.username,
                        badges: [
                            Badge(title: item.user.email, type: .role),
                            Badge(title: item.permission.title, type: .permission)
                        ]
                    )
                }
            }
            .assign(to: &$content)
    }
}
