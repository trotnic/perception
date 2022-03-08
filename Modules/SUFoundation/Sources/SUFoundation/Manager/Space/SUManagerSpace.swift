//
//  SUManagerSpace.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 12.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine

public protocol SUManagerSpace {
    var workspaces: CurrentValueSubject<[SUShallowWorkspace], Never> { get }

    func observe(for userId: String)
    func loadWorkspaces(for userId: String) async throws -> [SUShallowWorkspace]
    func createWorkspace(name: String, userId: String) async throws -> String
}

public struct SUManagerSpaceMock: SUManagerSpace {

    public private(set) var workspaces = CurrentValueSubject<[SUShallowWorkspace], Never>([])
    private let workspacesCallback: () -> [SUShallowWorkspace]

    public init(
        workspaces: @escaping () -> [SUShallowWorkspace] = { [] }
    ) {
        workspacesCallback = workspaces
    }

    public func observe(for userId: String) {
        workspaces.value = workspacesCallback()
    }
    public func loadWorkspaces(for userId: String) async throws -> [SUShallowWorkspace] { workspacesCallback() }
    public func createWorkspace(name: String, userId: String) async throws -> String { String(describing: self) }
}
