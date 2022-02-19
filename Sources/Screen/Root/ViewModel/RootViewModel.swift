//
//  RootViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 3.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import SUFoundation

public final class RootViewModel: ObservableObject {

    private let appState: SUAppStateProvider
    private let userManager: SUManagerUser

    public init(appState: SUAppStateProvider, userManager: SUManagerUser) {
        self.appState = appState
        self.userManager = userManager
    }
}

// MARK: - Public interface

public extension RootViewModel {

    func handleUserAuthenticationState() {
        appState.change(route: userManager.isAuthenticated ? .space : .authentication)
    }
}
