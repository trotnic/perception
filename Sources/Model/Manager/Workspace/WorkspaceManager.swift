//
//  WorkspaceManager.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 9.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public final class WorkspaceManager {

    private let repository: Repository
    private var currentWorkspace: SUWorkspace?

    public init(repository: Repository) {
        self.repository = repository
    }
}
