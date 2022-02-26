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

    public init(id: String) {
        self.id = id
    }
}

public extension SUWorkspaceMeta {
    static let empty = SUWorkspaceMeta(id: UUID().uuidString)
}

public struct SUShallowWorkspace {
    public let meta: SUWorkspaceMeta
    public let title: String

    public init(
        meta: SUWorkspaceMeta,
        title: String
    ) {
        self.meta = meta
        self.title = title
    }
}

public struct SUWorkspace {
    public let meta: SUWorkspaceMeta
    public let title: String
    public let documents: [SUShallowDocument]

    public init(
        meta: SUWorkspaceMeta,
        title: String,
        documents: [SUShallowDocument]
    ) {
        self.meta = meta
        self.title = title
        self.documents = documents
    }
//    enum CodingKeys: String, CodingKey {
//        case id
//        case title
//    }
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        meta = SUWorkspaceMeta(id: try container.decode(String.self, forKey: .id))
//        title = try container.decode(String.self, forKey: .title)
//
//    }
//
//    public func encode(to encoder: Encoder) throws {
//
//    }
}
