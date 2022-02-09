//
//  AuthorizationViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 1.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public final class AuthenticationViewModel: ObservableObject {

    @Published public var email: String = ""
    @Published public var password: String = ""

    private let environment: Environment

    private var userSession: UserSession {
        environment.userSession
    }

    private var state: AppState {
        environment.state
    }

    public init(environment: Environment = .dev) {
        self.environment = environment
    }

}

public extension AuthenticationViewModel {

    func signIn() {
        Task {
            do {
                try await userSession.signIn(email: email, password: password)
                await MainActor.run {
                    state.change(route: .space)
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

    func signUp() {
        Task {
            do {
                try await userSession.signUp(email: email, password: password)
                await MainActor.run {
                    state.change(route: .space)
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}
