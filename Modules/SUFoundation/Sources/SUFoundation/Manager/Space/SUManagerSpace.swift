//
//  SUManagerSpace.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 12.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

public protocol SUManagerSpace {
    func loadWorkspaces(for userId: String) async throws -> [SUShallowWorkspace]
    func createWorkspace(name: String, userId: String) async throws -> String
}

public struct SUManagerSpaceMock: SUManagerSpace {

    private let workspaces: () -> [SUShallowWorkspace]

    public init(workspaces: @escaping () -> [SUShallowWorkspace] = { [] }) {
        self.workspaces = workspaces
    }

    public func loadWorkspaces(for userId: String) async throws -> [SUShallowWorkspace] { workspaces() }
    public func createWorkspace(name: String, userId: String) async throws -> String { String(describing: self) }
}
