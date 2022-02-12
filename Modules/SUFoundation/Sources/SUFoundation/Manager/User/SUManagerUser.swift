//
//  SUManagerUser.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 12.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

public protocol SUManagerUser {
    var isAuthenticated: Bool { get }
    var userId: String { get }

    func signIn(email: String, password: String) async throws
    func signOut() throws
    func signUp(email: String, password: String) async throws
}

public struct SUManagerUserMock: SUManagerUser {
    public var isAuthenticated: Bool { false }
    public var userId: String { String(describing: self) }

    public func signIn(email: String, password: String) async throws {}
    public func signOut() throws {}
    public func signUp(email: String, password: String) async throws {}

    public init() {}
}
