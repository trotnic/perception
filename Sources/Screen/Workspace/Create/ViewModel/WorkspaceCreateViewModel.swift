//
//  WorkspaceCreateViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 23.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public final class WorkspaceCreateViewModel: ObservableObject {

    @Published var itemName: String = ""

    private let environment: Environment
    private let workspaceMeta: SUWorkspaceMeta

    private var state: AppState {
        environment.state
    }

    private var userSession: UserSession {
        environment.userSession
    }

    public init(meta: SUWorkspaceMeta, environment: Environment = .dev) {
        self.environment = environment
        workspaceMeta = meta
    }
}

public extension WorkspaceCreateViewModel {

    func backAction() {
        state.change(route: .back)
    }

    func createAction() {
        state.change(route: .create)
    }
}
