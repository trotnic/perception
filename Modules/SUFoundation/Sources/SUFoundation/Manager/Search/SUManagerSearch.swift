//
//  SUManagerSearch.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 6.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public protocol SUManagerSearch {
    func searchWorkspaces(for userId: String, with name: String) async throws -> [SUShallowWorkspace]
    func searchDocuments(for userId: String, with name: String) async throws -> [SUShallowDocument]
}

// MARK: - Mocks

public struct SUManagerSearchMock {

    private let workspacesCallback: () -> [SUShallowWorkspace]
    private let documentsCallback: () -> [SUShallowDocument]

    public init(
        workspaces: @escaping () -> [SUShallowWorkspace] = { [] },
        documents: @escaping () -> [SUShallowDocument] = { [] }
    ) {
        workspacesCallback = workspaces
        documentsCallback = documents
    }
}

extension SUManagerSearchMock: SUManagerSearch {

    public func searchWorkspaces(for userId: String, with name: String) async throws -> [SUShallowWorkspace] { workspacesCallback() }
    public func searchDocuments(for userId: String, with name: String) async throws -> [SUShallowDocument] { documentsCallback() }
}
