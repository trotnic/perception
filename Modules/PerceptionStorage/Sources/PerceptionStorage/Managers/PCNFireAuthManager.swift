//
//  PCNFireAuthManager.swift
//  
//
//  Created by Uladzislau Volchyk on 12.12.21.
//

import Foundation
import FirebaseAuth

public final class PCNFireAuthManager {
    
    private let auth = Auth.auth()

    public func signIn(email: String, password: String, completion: @escaping () -> Void) {
        auth.signIn(withEmail: email, password: password) { _, _ in
            completion()
        }
    }

    public func signUp(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { _, _ in
        }
    }

    public func checkUser() {
        print(auth.currentUser?.email)
    }
}
