//
//  Environment.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 14.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import Combine
import SwiftUIRouter

public final class Environment: ObservableObject {
    public static let dev = Environment()

    public let repository: Repository = LocalRepository()
    public private(set) lazy var state = AppState(navigator: navigator)
    public let navigator = Navigator()

    public private(set) lazy var workspaceManager = WorkspaceManager(repository: repository)
    public private(set) lazy var spaceManager = SpaceManager(repository: repository)
}
