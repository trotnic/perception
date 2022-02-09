//
//  AuthorizationViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 1.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public final class AuthenticationViewModel: ObservableObject {

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

    func process(email: String, password: String) {
        Task {
            try await userSession.authorize(email: email, password: password)
            await MainActor.run {
                state.change(route: .space)
            }
        }
    }

}
