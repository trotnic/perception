//
//  Workspace.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 9.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import Firebase

public struct SUWorkspaceMeta: Identifiable {
    public let id: String

    public init(
        id: String
    ) {
        self.id = id
    }
}

public extension SUWorkspaceMeta {
    static let empty = SUWorkspaceMeta(id: UUID().uuidString)
}

public struct SUShallowWorkspace {
    public let meta: SUWorkspaceMeta
    public let title: String
    public let emoji: String

    public init(
        meta: SUWorkspaceMeta,
        title: String,
        emoji: String
    ) {
        self.meta = meta
        self.title = title
        self.emoji = emoji
    }
}

public struct SUWorkspace {
    public let meta: SUWorkspaceMeta
    public let ownerId: String
    public let title: String
    public let documents: [SUShallowDocument]
    public let members: [SUShallowWorkspaceMember]
    public let emoji: String

    public init(
        meta: SUWorkspaceMeta,
        ownerId: String,
        title: String,
        documents: [SUShallowDocument],
        members: [SUShallowWorkspaceMember],
        emoji: String
    ) {
        self.meta = meta
        self.ownerId = ownerId
        self.title = title
        self.documents = documents
        self.members = members
        self.emoji = emoji
    }
}

public struct SUShallowWorkspaceMember {
    public let id: String
    public let permission: Int
}

public struct SUWorkspaceMember {
    public let user: SUUser
    public let permission: SUWorkspacePermission
}

public enum SUWorkspacePermission: Int {
    case admin
    case editor
    case reader

    public var title: String {
        switch self {
        case .admin:
            return "admin"
        case .editor:
            return "editor"
        case .reader:
            return "reader"
        }
    }
}
