//
//  SUManagerWorkspace.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 12.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

public protocol SUManagerWorkspace {
    func loadWorkspace(id: String) async throws -> SUWorkspace
    func createDocument(title: String, workspaceId: String, userId: String) async throws -> String
}

public struct SUManagerWorkspaceMock: SUManagerWorkspace {
    public func loadWorkspace(id: String) async throws -> SUWorkspace { .init(meta: .empty, title: "", documents: []) }
    public func createDocument(title: String, workspaceId: String, userId: String) async throws -> String { String(describing: self) }

    public init() {}
}
