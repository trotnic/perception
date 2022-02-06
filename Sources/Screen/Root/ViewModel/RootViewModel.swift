//
//  RootViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 3.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public final class RootViewModel: ObservableObject {

    private let environment: Environment

    private var state: AppState {
        environment.state
    }

    private var userSession: UserSession {
        environment.userSession
    }

    public init(environment: Environment = .dev) {
        self.environment = environment
        handleUserAuthenticationState()
    }
}

// MARK: - Private interface

private extension RootViewModel {

    func handleUserAuthenticationState() {
        state.change(route: userSession.isAuthenticated ? .space : .authentication)
    }
}
