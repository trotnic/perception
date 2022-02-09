//
//  ToolbarSettingsViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 9.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public final class ToolbarSettingsViewModel: ObservableObject {

    private let environment: Environment

    private var state: AppState {
        environment.state
    }

    public init(environment: Environment = .dev) {
        self.environment = environment
    }

}

public extension ToolbarSettingsViewModel {

    func accountAction() {
        state.change(route: .account)
    }
}
