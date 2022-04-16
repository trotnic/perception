//
//  Document.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 9.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public struct SUDocumentMeta: Identifiable, Equatable {
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
    static let empty = SUDocumentMeta(id: .empty, workspaceId: .empty)
}

@dynamicMemberLookup
public struct SUShallowDocument {
    public let meta: SUDocumentMeta
    public let title: String
    public let emoji: String
    public let dateCreated: Date

    public init(
        meta: SUDocumentMeta,
        title: String,
        emoji: String,
        dateCreated: Date
    ) {
        self.meta = meta
        self.title = title
        self.emoji = emoji
        self.dateCreated = dateCreated
    }

    subscript(dynamicMember member: KeyPath<SUDocumentMeta, UUID>) -> UUID {
        meta[keyPath: member]
    }
}

public struct SUDocument: Equatable {
  public let meta: SUDocumentMeta
  public let ownerId: String
  public let title: String
  public let emoji: String
  public let dateCreated: Date
  public let dateEdited: Date
  public let items: [SUDocumentBlock]

  public static func == (lhs: SUDocument, rhs: SUDocument) -> Bool {
    lhs.meta == rhs.meta
  }
}

public extension SUDocument {
    static let empty = SUDocument(
      meta: .empty,
      ownerId: .empty,
      title: .empty,
      emoji: .empty,
      dateCreated: .now,
      dateEdited: .now,
      items: []
    )
}
