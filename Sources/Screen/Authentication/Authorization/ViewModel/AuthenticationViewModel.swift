//
//  AuthorizationViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 1.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine
import Foundation
import SUFoundation

public final class AuthenticationViewModel: ObservableObject {

    @Published public var email: String = .empty
    @Published public var password: String = .empty
    @Published public var errorText: String = .empty
    @Published public private(set) var isSignButtonActive: Bool = false

    private var disposeBag = Set<AnyCancellable>()

    private let appState: SUAppStateProvider
    private let userManager: SUManagerUser

    public init(appState: SUAppStateProvider,
                userManager: SUManagerUser) {
        self.appState = appState
        self.userManager = userManager
        $password
            .merge(with: $email)
            .map { [self] _ in
                !(email.isEmpty || password.isEmpty)
            }
            .assign(to: &$isSignButtonActive)
    }
}

public extension AuthenticationViewModel {

    func signIn() {
        Task {
            do {
                try await userManager.signIn(email: email, password: password)
                await MainActor.run {
                    appState.change(route: .space)
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

    func signUp() {
        Task {
            do {
                try await userManager.signUp(email: email, password: password)
                await MainActor.run {
                    appState.change(route: .space)
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}
