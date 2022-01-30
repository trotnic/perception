//
//  Document.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 9.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public struct SUDocumentMeta: Identifiable {
    public let id: UUID
    public let shelfId: UUID
    public let workspaceId: UUID
}

public extension SUDocumentMeta {
    static let empty = SUDocumentMeta(id: UUID(), shelfId: UUID(), workspaceId: UUID())
}

@dynamicMemberLookup
public struct SUDocument {
    public let meta: SUDocumentMeta
    public let title: String

    subscript(dynamicMember member: KeyPath<SUDocumentMeta, UUID>) -> UUID {
        meta[keyPath: member]
    }
}
