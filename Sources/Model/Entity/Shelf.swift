//
//  Shelf.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 9.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public struct SUShelfMeta: Identifiable {
    public let id: String
    public let workspaceId: String
}

public extension SUShelfMeta {
    static let empty = SUShelfMeta(id: UUID().uuidString, workspaceId: UUID().uuidString)
}

@dynamicMemberLookup
public struct SUShallowShelf {
    public let meta: SUShelfMeta
    public let title: String

    subscript(dynamicMember member: KeyPath<SUShelfMeta, String>) -> String {
        meta[keyPath: member]
    }
}

public struct SUShelf {
    public let meta: SUShelfMeta
    public let title: String
    public let documents: [SUShallowDocument]
}
