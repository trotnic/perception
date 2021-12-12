//
//  PCNFireManager.swift
//  
//
//  Created by Uladzislau Volchyk on 12.12.21.
//

import Foundation
import Firebase

public final class PCNFireManager {
    
    public static let shared = PCNFireManager()
    
    public let authManager: PCNFireAuthManager
    public let storeManager: PCNFireStoreManager
    
    private init() {
        FirebaseApp.configure()
        authManager = PCNFireAuthManager()
        storeManager = PCNFireStoreManager()
    }
}
