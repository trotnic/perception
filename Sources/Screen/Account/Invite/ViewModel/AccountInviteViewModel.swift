//
//  AccountInviteViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 13.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine
import Foundation
import SUFoundation

public final class AccountInviteViewModel: ObservableObject {

    @Published public private(set) var items: [ListItem] = []

    private let appState: SUAppStateProvider
    private let accountManager: SUManagerAccount
    private let userMeta: SUUserMeta

    private var disposeBag = Set<AnyCancellable>()

    public init(
        appState: SUAppStateProvider,
        accountManager: SUManagerAccount,
        userMeta: SUUserMeta
    ) {
        self.appState = appState
        self.accountManager = accountManager
        self.userMeta = userMeta

        setupBindings()
    }
}

public extension AccountInviteViewModel {

    func loadAction() {
        accountManager.observeInvites(for: userMeta.id)
    }

    func backAction() {
        appState.change(route: .back)
    }
}

public extension AccountInviteViewModel {

    struct ListItem: Identifiable {
        public let id = UUID()
        public let title: String
        public let emoji: String
        public let badges: [Badge]
        public let confirmAction: () -> Void
        public let rejectAction: () -> Void

        init(
            title: String,
            emoji: String,
            badges: [Badge],
            confirmAction: @autoclosure @escaping () -> Void,
            rejectAction: @autoclosure @escaping () -> Void
        ) {
            self.title = title
            self.emoji = emoji
            self.badges = badges
            self.confirmAction = confirmAction
            self.rejectAction = rejectAction
        }
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

private extension AccountInviteViewModel {

    func setupBindings() {
        accountManager
            .invites
            .map { [unowned self] workspaces in
                workspaces.map { workspace in
                    ListItem(
                        title: workspace.title,
                        emoji: workspace.emoji,
                        badges: [
                            // TODO: Plural formatting
                            Badge(title: "\(workspace.documentsCount) documents", type: .documents),
                            Badge(title: "\(workspace.membersCount) members", type: .members),
                        ],
                        confirmAction: self.confirmAction(workspaceId: workspace.meta.id),
                        rejectAction: self.rejectAction(workspaceId: workspace.meta.id)
                    )
                }
            }
            .assign(to: &$items)
    }

    func confirmAction(workspaceId: String) {
        accountManager.confirmInvite(userId: userMeta.id, workspaceId: workspaceId)
    }

    func rejectAction(workspaceId: String) {
        accountManager.rejectInvite(userId: userMeta.id, workspaceId: workspaceId)
    }
}
