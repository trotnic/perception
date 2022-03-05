//
//  ToolbarSettingsViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 9.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import SUFoundation

public final class ToolbarSettingsViewModel: ObservableObject {

    private let appState: SUAppStateProvider
    private let sessionManager: SUManagerUserIdentifiable

    public init(
        appState: SUAppStateProvider,
        sessionManager: SUManagerUserIdentifiable
    ) {
        self.appState = appState
        self.sessionManager = sessionManager
    }

}

public extension ToolbarSettingsViewModel {

    func accountAction() {
        appState.change(route: .account(SUUserMeta(id: sessionManager.userId)))
    }
}
