//
//  ToolbarMembersViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 7.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import SUFoundation

public final class ToolbarMembersViewModel: ObservableObject {

    private let appState: SUAppStateProvider
    private let workspaceMeta: SUWorkspaceMeta

    public init(
        appState: SUAppStateProvider,
        workspaceMeta: SUWorkspaceMeta
    ) {
        self.appState = appState
        self.workspaceMeta = workspaceMeta
    }
}

public extension ToolbarMembersViewModel {

    func membersAction() {
        appState.change(route: .members(workspaceMeta))
    }
}
