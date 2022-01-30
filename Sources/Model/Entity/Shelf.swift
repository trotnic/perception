//
//  Shelf.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 9.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public struct SUShelfMeta: Identifiable {
    public let id: UUID
    public let workspaceId: UUID
}

public extension SUShelfMeta {
    static let empty = SUShelfMeta(id: UUID(), workspaceId: UUID())
}

@dynamicMemberLookup
public struct SUShelf {
    public let meta: SUShelfMeta
    public let title: String

    subscript(dynamicMember member: KeyPath<SUShelfMeta, UUID>) -> UUID {
        meta[keyPath: member]
    }
}
