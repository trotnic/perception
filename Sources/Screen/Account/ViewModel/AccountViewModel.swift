//
//  AccountViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 8.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import SUFoundation

public final class AccountViewModel: ObservableObject {

    @Published var username: String = "Kek Lolman"

    private let appState: SUAppStateProvider
    private let userManager: SUManagerUser

    public init(appState: SUAppStateProvider,
                userManager: SUManagerUser) {
        self.appState = appState
        self.userManager = userManager
    }
}

public extension AccountViewModel {

    func backAction() {
        appState.change(route: .back)
    }

    func logoutAction() {
        do {
            try userManager.signOut()
            appState.change(route: .authentication)
        } catch {
            print(error)
        }
    }
}