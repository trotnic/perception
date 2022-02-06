//
//  AuthorizationViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 1.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public final class AuthorizationViewModel: ObservableObject {

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

public extension AuthorizationViewModel {

    func process(email: String, password: String) {
        userSession.authorize(email: email, password: password) { [state] result in
            switch result {
            case .success:
                state.change(route: .space)
            case .failure(let error):
                print(error)
            }
        }
    }

}
