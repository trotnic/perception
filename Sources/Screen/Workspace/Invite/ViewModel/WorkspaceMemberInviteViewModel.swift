//
//  WorkspaceMemberInviteViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 13.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine
import Foundation
import SUFoundation

public final class WorkspaceMemberInviteViewModel: ObservableObject {

    @Published public var email: String = .empty

    private let appState: SUAppStateProvider
    private let inviteManager: SUManagerInvite
    private let workspaceMeta: SUWorkspaceMeta

    public init(
        appState: SUAppStateProvider,
        inviteManager: SUManagerInvite,
        workspaceMeta: SUWorkspaceMeta
    ) {
        self.appState = appState
        self.inviteManager = inviteManager
        self.workspaceMeta = workspaceMeta
    }
}

public extension WorkspaceMemberInviteViewModel {

    func inviteAction() {
        Task {
            do {
                try await inviteManager.inviteUser(with: email, in: workspaceMeta.id)
            } catch {
                
            }
        }
    }
}
