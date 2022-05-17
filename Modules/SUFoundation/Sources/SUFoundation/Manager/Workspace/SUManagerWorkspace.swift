//
//  SUManagerWorkspace.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 12.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine

public protocol SUManagerWorkspace {

    var workspace: CurrentValueSubject<SUWorkspace, Never> { get }

    func observe(workspaceId: String)
    func createDocument(title: String, workspaceId: String, userId: String) async throws -> String
    func loadWorkspace(id: String) async throws -> SUWorkspace

    func updateWorkspace(id: String, title: String) async throws
    func updateWorkspace(id: String, emoji: String) async throws

    func deleteWorkspace(id: String, userId: String) async throws
}

public final class SUManagerWorkspaceMock: SUManagerWorkspace {

    private let metaCallback: () -> SUWorkspaceMeta
    private let ownerIdCallback: () -> String
    private let titleCallback: () -> String
    private let documentsCallback: () -> [SUShallowDocument]
    private let membersCountCallback: () -> Int
    private let emojiCallback: () -> String

    public var workspace = CurrentValueSubject<SUWorkspace, Never>(.empty)

    public init(
        meta: @escaping () -> SUWorkspaceMeta = { .empty },
        ownerId: @escaping () -> String = { .empty },
        title: @escaping () -> String = { .empty },
        documents: @escaping () -> [SUShallowDocument] = { [] },
        membersCount: @escaping () -> Int = { .zero },
        emoji: @escaping () -> String = { "" }
    ) {
        self.metaCallback = meta
        self.ownerIdCallback = ownerId
        self.titleCallback = title
        self.documentsCallback = documents
        self.membersCountCallback = membersCount
        self.emojiCallback = emoji
    }

    public func observe(workspaceId: String) {
        workspace.value = SUWorkspace(
            meta: metaCallback(),
            ownerId: ownerIdCallback(),
            title: titleCallback(),
            documents: documentsCallback(),
            membersCount: membersCountCallback(),
            emoji: emojiCallback(),
            dateCreated: .now
        )
    }
    public func createDocument(title: String, workspaceId: String, userId: String) async throws -> String { String(describing: self) }
    public func loadWorkspace(id: String) async throws -> SUWorkspace {
        SUWorkspace(
            meta: metaCallback(),
            ownerId: ownerIdCallback(),
            title: titleCallback(),
            documents: documentsCallback(),
            membersCount: membersCountCallback(),
            emoji: emojiCallback(),
            dateCreated: .now
        )
    }
    public func updateWorkspace(id: String, title: String) async throws {}
    public func updateWorkspace(id: String, emoji: String) async throws {}
    public func deleteWorkspace(id: String, userId: String) async throws {}
}
