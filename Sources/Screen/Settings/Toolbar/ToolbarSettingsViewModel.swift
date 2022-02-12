//
//  ToolbarSettingsViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 9.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public final class ToolbarSettingsViewModel: ObservableObject {

    private let appState: SUAppStateProvider

    public init(appState: SUAppStateProvider) {
        self.appState = appState
    }

}

public extension ToolbarSettingsViewModel {

    func accountAction() {
        appState.change(route: .account)
    }
}
