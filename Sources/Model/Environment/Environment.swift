//
//  Environment.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 14.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import Combine
import SwiftUIRouter
import SUFoundation

public final class Environment: ObservableObject {
    public static let dev = Environment()
    public static let preview = Environment(param: 42)

    init(param: Int) {
        repository = nil
        state = nil
        navigator = nil
        userSession = nil
        workspaceManager = nil
        spaceManager = nil
    }

    init() {
        FirebaseApp.configure()
        let repository = FireRepository()
        self.repository = repository
        userSession = UserSession()
        let navigator = Navigator()
        self.navigator = navigator
        state = AppState(navigator: navigator)
        workspaceManager = WorkspaceManager(repository: repository)
        spaceManager = SpaceManager(repository: repository)
    }

    public let repository: FireRepository!
    public let state: AppState!
    public let navigator: Navigator!

    public let userSession: UserSession!

    public let workspaceManager: WorkspaceManager!
    public let spaceManager: SpaceManager!
}
