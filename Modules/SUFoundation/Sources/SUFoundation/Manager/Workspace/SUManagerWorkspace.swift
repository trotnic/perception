//
//  SUManagerWorkspace.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 12.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine

public protocol SUManagerWorkspace {

    var workspace: PassthroughSubject<SUWorkspace, Never> { get }

    func createDocument(title: String, workspaceId: String, userId: String) async throws -> String
    func loadWorkspace(id: String) async throws -> SUWorkspace
    func updateWorkspace(id: String, title: String) async throws
    func deleteWorkspace(id: String, userId: String) async throws
}

public final class SUManagerWorkspaceMock: SUManagerWorkspace {

    private let title: () -> String
    private let documents: () -> [SUShallowDocument]
    private let meta: () -> SUWorkspaceMeta

    public var workspace: PassthroughSubject<SUWorkspace, Never> = .init()

    public init(
        meta: @escaping () -> SUWorkspaceMeta = { .empty },
        title: @escaping () -> String = { .empty },
        documents: @escaping () -> [SUShallowDocument] = { [] }
    ) {
        self.meta = meta
        self.title = title
        self.documents = documents
    }

    public func createDocument(title: String, workspaceId: String, userId: String) async throws -> String { String(describing: self) }
    public func loadWorkspace(id: String) async throws -> SUWorkspace {
        SUWorkspace(
            meta: meta(),
            title: title(),
            documents: documents()
        )
    }
    public func updateWorkspace(id: String, title: String) async throws {}
    public func deleteWorkspace(id: String, userId: String) async throws {}
}
