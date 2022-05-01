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
    @Published public var isInviteButtonActive: Bool = false

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
    
    setupBindings()
  }
}

// MARK: - Public actions

public extension WorkspaceMemberInviteViewModel {

    func inviteAction() {
        Task {
            do {
                try await inviteManager.inviteUser(
                  with: email,
                  in: workspaceMeta.id
                )
            } catch {
                // TODO: Error handling
            }
        }
    }

    func backAction() {
        appState.change(route: .back)
    }
}

// MARK: - Private interface

private extension WorkspaceMemberInviteViewModel {

    // TODO: 25 characters check
    func setupBindings() {
        $email
            .map(\.isEmpty)
            .removeDuplicates()
            .map(!)
            .assign(to: &$isInviteButtonActive)
    }
}
