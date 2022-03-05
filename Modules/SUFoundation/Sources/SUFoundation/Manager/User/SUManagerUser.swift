//
//  SUManagerUser.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 12.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

public typealias SUManagerUserPrime = SUManagerUser & SUManagerSession

public protocol SUManagerUserIdentifiable {
    var userId: String { get }
}

public protocol SUManagerSession: SUManagerUserIdentifiable {
    var isAuthenticated: Bool { get }

    func signIn(email: String, password: String) async throws
    func signOut() throws
    func signUp(email: String, password: String) async throws
}

public protocol SUManagerUser {

    func fetch(id: String) async throws -> SUUser
}

// MARK: - Mocks

public struct SUManagerUserPrimeMock {

    private let userIdCallback: () -> String
    private let isAuthenticatedCallback: () -> Bool
    private let userCallback: () -> SUUser

    public init(
        userId: @escaping () -> String = { .empty },
        isAuthenticated: @escaping () -> Bool = { false },
        user: @escaping () -> SUUser = { .empty }
    ) {
        userIdCallback = userId
        isAuthenticatedCallback = isAuthenticated
        userCallback = user
    }
}

extension SUManagerUserPrimeMock: SUManagerUserPrime {
    public var isAuthenticated: Bool { isAuthenticatedCallback() }
    public var userId: String { userIdCallback() }

    public func signIn(email: String, password: String) async throws {}
    public func signOut() throws {}
    public func signUp(email: String, password: String) async throws {}

    public func fetch(id: String) async throws -> SUUser { userCallback() }
}
