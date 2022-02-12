//
//  UserManager.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 14.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public final class UserManager {

    private let userSession: UserSession

    public init(session: UserSession) {
        userSession = session
    }
}

public extension UserManager {

    var isAuthenticated: Bool {
        userSession.isAuthenticated
    }

    var userId: String {
        userSession.userId
    }

    func signIn(email: String, password: String) async throws {
        try await userSession.signIn(email: email, password: password)
    }

    func signOut() throws {
        try userSession.signOut()
    }

    func signUp(email: String, password: String) async throws {
        try await userSession.signUp(email: email, password: password)
    }
}
