//
//  AuthorizationViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 1.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import SUFoundation

public final class AuthenticationViewModel: ObservableObject {

    @Published public var email: String = ""
    @Published public var password: String = ""

    private let appState: SUAppStateProvider
    private let userManager: SUManagerUser

    public init(appState: SUAppStateProvider,
                userManager: SUManagerUser) {
        self.appState = appState
        self.userManager = userManager
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
