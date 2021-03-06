//
//  AccountManager.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 13.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine
import Foundation

public final class AccountManager: ObservableObject {

    public private(set) var invites = CurrentValueSubject<[SUShallowWorkspace], Never>([])

    private let repository: Repository

    public init(
        repository: Repository
    ) {
        self.repository = repository
    }
}

extension AccountManager: SUManagerAccount {

    public func observeInvites(for userId: String) {
        Task {
            do {
                try await repository.startListenInvites(userId: userId)
                { [weak self] workspaces in
                    guard let self = self else { return }
                    Task {
                        do {
                            await MainActor.run {
                                self.invites.value = workspaces
                            }
                        } catch {
                            
                        }
                    }
                }
            } catch {
            }
        }
    }

    public func confirmInvite(userId: String, workspaceId: String) {
        repository.confirmInvite(userId: userId, workspaceId: workspaceId)
    }

    public func rejectInvite(userId: String, workspaceId: String) {
        repository.rejectInvite(userId: userId, workspaceId: workspaceId)
    }
}
