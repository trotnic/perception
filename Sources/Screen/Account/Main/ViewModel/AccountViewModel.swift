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

    @Published public var imagePath: String?
    @Published public var image: Data?
    @Published public var username: String = .empty
    @Published public var position: String = .empty
    @Published public private(set) var email: String = .empty

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

// MARK: - Public interface

public extension AccountViewModel {

    func backAction() {
        appState.change(route: .back)
    }

    func invitesAction() {
        appState.change(route: .invites(userMeta))
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

    func loadAction() {
        userManager.setup(id: userMeta.id)
    }
}

// MARK: - Private interface

private extension AccountViewModel {

    func setupBindings() {
        userManager
            .user
            .receive(on: DispatchQueue.main)
            .sink { user in
                self.username = user.username
                self.email = user.email
                self.imagePath = user.avatarPath
            }
            .store(in: &disposeBag)

        $image
            .removeDuplicates()
            .drop(while: { $0 == nil })
            .sink { output in
                if let data = output {
                    self.userManager.uploadImage(data: data, userId: self.userMeta.id)
                }
            }
            .store(in: &disposeBag)
    }
}

extension Optional {
    var isEmpty: Bool {
        switch self {
        case .none:
            return true
        case .some:
            return false
        }
    }
}
