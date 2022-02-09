//
//  AccountViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 8.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public final class AccountViewModel: ObservableObject {

    @Published var username: String

    private let environment: Environment
    private var state: AppState {
        environment.state
    }

    private var userSession: UserSession {
        environment.userSession
    }

    public init(environment: Environment = .dev) {
        self.environment = environment
        username = "Kek Lolman"
    }

}

public extension AccountViewModel {

    func backAction() {
        state.change(route: .back)
    }

    func logoutAction() {
        do {
            try userSession.signOut()
            state.change(route: .authentication)
        } catch {
            print(error)
        }
    }
}
