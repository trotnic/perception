//
//  UserManager.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 14.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine
import Foundation

public final class UserManager {

    private let repository: Repository
    private let userSession: UserSession

    public let user = CurrentValueSubject<SUUser, Never>(.empty)

    public init(
        repository: Repository,
        userSession: UserSession
    ) {
        self.repository = repository
        self.userSession = userSession
    }

    deinit {
        repository.stopListen(with: user.value.meta.id)
    }
}

extension UserManager: SUManagerSession {

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

extension UserManager: SUManagerUser {

    public func setup(id: String) {
        repository.startListenUser(with: id) { user in
            self.user.value = user
        }
    }

    public func fetch(id: String) async throws -> SUUser {
        try await repository.user(with: id)
    }

    public func update(id: String, name: String) async throws {
        try await repository.updateUser(with: id, name: name)
    }

    public func uploadImage(data: Data, userId: String) {
        repository.uploadImage(data: data, userId: userId)
    }
}
