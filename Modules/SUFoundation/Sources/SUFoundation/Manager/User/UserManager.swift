//
//  UserManager.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 14.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public final class UserManager {

    private let repository: Repository
    private let userSession: UserSession

    public init(
        repository: Repository,
        userSession: UserSession
    ) {
        self.repository = repository
        self.userSession = userSession
    }
}

extension UserManager: SUManagerSession {

    public func fetch(id: String) async throws -> SUUser {
        try await repository.user(with: id)
    }
}

extension UserManager: SUManagerUser {

    public var isAuthenticated: Bool {
        userSession.isAuthenticated
    }

    public var userId: String {
        userSession.userId
    }

    public func signIn(email: String, password: String) async throws {
        try await userSession.signIn(email: email, password: password)
    }

    public func signOut() throws {
        try userSession.signOut()
    }

    public func signUp(email: String, password: String) async throws {
        try await userSession.signUp(email: email, password: password)
    }
}
