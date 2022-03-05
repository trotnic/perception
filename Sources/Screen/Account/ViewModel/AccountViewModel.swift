//
//  AccountViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 8.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine
import Foundation
import SUFoundation

public final class AccountViewModel: ObservableObject {

    @Published public var username: String = ""
    @Published public private(set) var email: String = ""

    private let appState: SUAppStateProvider
    private let userManager: SUManagerUserPrime
    private let userMeta: SUUserMeta

    private var disposeBag = Set<AnyCancellable>()

    public init(
        appState: SUAppStateProvider,
        userManager: SUManagerUserPrime,
        userMeta: SUUserMeta
    ) {
        self.appState = appState
        self.userManager = userManager
        self.userMeta = userMeta
        setupBindings()
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

    func saveAction() {
        Task {
            do {
                try await userManager.update(id: userMeta.id, name: username)
            } catch {
                print(error)
            }
        }
    }

    func resetAction() {
        username = userManager.user.value.username
    }

    func load() {
        userManager.setup(id: userMeta.id)
    }
}

private extension AccountViewModel {

    func setupBindings() {
        userManager
            .user
            .receive(on: DispatchQueue.main)
            .sink { user in
                self.username = user.username
                self.email = user.email
            }
            .store(in: &disposeBag)
    }
}
