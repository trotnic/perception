//
//  User.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 5.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public struct SUUserMeta {
    public let id: String

    public init(id: String) {
        self.id = id
    }
}

public extension SUUserMeta {
    static let empty = SUUserMeta(id: UUID().uuidString)
}

public struct SUUser {
    public let meta: SUUserMeta
    public let username: String
    public let email: String
    public let invites: [SUMemberInvite]
    public let avatarPath: String?

    public init(
        meta: SUUserMeta,
        username: String,
        email: String,
        invites: [SUMemberInvite],
        avatarPath: String?
    ) {
        self.meta = meta
        self.username = username
        self.email = email
        self.invites = invites
        self.avatarPath = avatarPath
    }
}

public extension SUUser {
    static let empty = SUUser(meta: .empty,
                              username: .empty,
                              email: .empty,
                              invites: [],
                              avatarPath: nil)
}
