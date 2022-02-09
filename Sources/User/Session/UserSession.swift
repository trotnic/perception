//
//  UserSession.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 1.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import FirebaseAuth

public final class UserSession {

    private var auth: Auth {
        Auth.auth()
    }
}

public extension UserSession {

    var isAuthenticated: Bool {
        !(auth.currentUser?.isAnonymous ?? true)
    }

    var userId: String? {
        auth.currentUser?.uid
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
