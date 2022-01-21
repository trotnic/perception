//
//  Environment.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 14.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import Combine

public final class Environment: ObservableObject {
    public static let dev = Environment()

    public let repository: Repository = LocalRepository()
    public let state = AppState()

    private(set) lazy var workspaceManager = WorkspaceManager(repository: repository)
    private(set) lazy var spaceManager = SpaceManager(repository: repository)
}
