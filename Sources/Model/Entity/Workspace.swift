//
//  Workspace.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 9.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public struct SUWorkspaceMeta: Identifiable {
    public let id: UUID
}

public extension SUWorkspaceMeta {
    static let empty = SUWorkspaceMeta(id: UUID())
}

public struct SUWorkspace {
    public let meta: SUWorkspaceMeta
    public let title: String
}
