//
//  Document.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 9.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public struct SUDocumentMeta: Identifiable {
    public let id: String
    public let workspaceId: String

    public init(
        id: String,
        workspaceId: String
    ) {
        self.id = id
        self.workspaceId = workspaceId
    }
}

public extension SUDocumentMeta {
    static let empty = SUDocumentMeta(id: UUID().uuidString, workspaceId: UUID().uuidString)
}

@dynamicMemberLookup
public struct SUShallowDocument {
    public let meta: SUDocumentMeta
    public let title: String
    public let emoji: String

    public init(
        meta: SUDocumentMeta,
        title: String,
        emoji: String
    ) {
        self.meta = meta
        self.title = title
        self.emoji = emoji
    }

    subscript(dynamicMember member: KeyPath<SUDocumentMeta, UUID>) -> UUID {
        meta[keyPath: member]
    }
}

public struct SUDocument {
    public let meta: SUDocumentMeta
    public let ownerId: String
    public let title: String
    public let text: String
    public let emoji: String
}
