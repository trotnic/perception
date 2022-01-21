//
//  Workspace.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 9.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public struct SUWorkspace: Identifiable {
    public let id: UUID
    public let title: String
    public let iconText: String
    public let membersCount: Int
    public let dateCreated: Date
}
