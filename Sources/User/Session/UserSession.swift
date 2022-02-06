//
//  UserSession.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 1.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

let voidValue: Void = ()

import Foundation
import FirebaseAuth

public final class UserSession {

    private var auth: Auth {
        Auth.auth()
    }

    init() {
        
    }
}

public extension UserSession {

    var isAuthenticated: Bool {
        !(auth.currentUser?.isAnonymous ?? true)
    }

    var userId: String? {
        auth.currentUser?.uid
    }

    func authorize(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(voidValue))
        }
    }

    func signOut(completion: (Result<Void, Error>) -> Void) {
        do {
            try auth.signOut()
            completion(.success(voidValue))
        } catch {
            completion(.failure(error))
        }
    }

    func register(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            
        }
    }
}
