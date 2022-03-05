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
    static let empty = SUUserMeta(id: .empty)
}

public struct SUUser {
    public let meta: SUUserMeta
    public let username: String
    public let email: String

    public init(
        meta: SUUserMeta,
        username: String,
        email: String
    ) {
        self.meta = meta
        self.username = username
        self.email = email
    }
}

public extension SUUser {
    static let empty = SUUser(meta: .init(id: .empty), username: .empty, email: .empty)
}
