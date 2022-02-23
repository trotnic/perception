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

    func loadWorkspace(id: String) async throws -> SUWorkspace
    func createDocument(title: String, workspaceId: String, userId: String) async throws -> String
    func deleteWorkspace(id: String, userId: String) async throws
}

public final class SUManagerWorkspaceMock: SUManagerWorkspace {

    public var workspace: PassthroughSubject<SUWorkspace, Never> = .init()
    public func loadWorkspace(id: String) {}
    public func loadWorkspace(id: String) async throws -> SUWorkspace { .init(meta: .empty, title: "", documents: []) }
    public func createDocument(title: String, workspaceId: String, userId: String) async throws -> String { String(describing: self) }
    public func deleteWorkspace(id: String, userId: String) async throws {}

    public init() {}
}
