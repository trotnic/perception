//
//  UserSession.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 1.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

public final class UserSession {

    private let auth: Auth

    public init(auth: Auth) {
        self.auth = auth
    }
}

public extension UserSession {

    var isAuthenticated: Bool {
        auth.currentUserUnwrapped.isAuthenticated
    }

    var userId: String {
        auth.currentUserUnwrapped.uid
    }

    func signIn(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
    }

    func signOut() throws {
        try auth.signOut()
    }

    func signUp(email: String, password: String) async throws {
        try await auth.createUser(withEmail: email, password: password)
    }
}
