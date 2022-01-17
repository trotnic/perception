//
//  AppState.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 15.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

final class AppState: ObservableObject {

    @Published var currentSelection: Screen = .space

    enum Screen {
        case space
        case workspace(UUID)
        case shelf(UUID)
        case document(UUID)
    }

    func change(route: Screen) {
        switch route {
        case .space:
            break
        case .workspace(let id):
            break
        case .shelf(let id):
            break
        case .document(let id):
            break
        }
        
        currentSelection = route
    }
}
