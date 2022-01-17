//
//  Environment.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 14.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import Combine

final class Environment: ObservableObject {
    static let dev = Environment()

    let repository: Repository = LocalRepository()
    let state = AppState()

    private(set) lazy var workspaceManager = WorkspaceManager(repository: repository)
    private(set) lazy var spaceManager = SpaceManager(repository: repository)
}
