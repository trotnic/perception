//
//  AccountViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 8.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import SUFoundation

public final class AccountViewModel: ObservableObject {

    @Published public var username: String = ""
    @Published public private(set) var email: String = ""

    private let appState: SUAppStateProvider
    private let userManager: SUManagerUserPrime
    private let userMeta: SUUserMeta

    public init(
        appState: SUAppStateProvider,
        userManager: SUManagerUserPrime,
        userMeta: SUUserMeta
    ) {
        self.appState = appState
        self.userManager = userManager
        self.userMeta = userMeta
    }
}

public extension AccountViewModel {

    func backAction() {
        appState.change(route: .back)
    }

    func logoutAction() {
        do {
            try userManager.signOut()
            appState.change(route: .authentication)
        } catch {
            print(error)
        }
    }

    func load() {
        Task {
            do {
                let user = try await userManager.fetch(id: userMeta.id)
                await MainActor.run {
                    username = user.username
                    email = user.email
                }
            } catch {
                print(error)
            }
        }
    }
}
