//
//  PCNFireStoreManager.swift
//  
//
//  Created by Uladzislau Volchyk on 12.12.21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public enum Collections: String {
    case workspaces
    case documents
}

public final class PCNFireStoreManager {
    
    private let firestore = Firestore.firestore()
    
    public func check() {
        
        let workspace = firestore.collection("workspaces").document()
        
        try? workspace.setData(
            from: Workspace(
                id: workspace.documentID,
                shelfs: [],
                timestamp: Date().timeIntervalSince1970
            )
        )
        
        
    }
}
