//
//  Shelf.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 9.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public struct SUShelf: Identifiable {
    public let id: UUID
    public let workspaceId: UUID
    public let title: String
    public let dateCreated: Date
}
