//
//  ToolbarSearchViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 6.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import SUFoundation

public final class ToolbarSearchViewModel: ObservableObject {

    private let appState: SUAppStateProvider

    public init(
        appState: SUAppStateProvider
    ) {
        self.appState = appState
    }
}

public extension ToolbarSearchViewModel {

    func searchAction() {
        appState.change(route: .search)
    }
}
