//
//  SearchManager.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 6.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine
import Foundation

public final class SearchManager: ObservableObject {

    private let repository: Repository

    public init(
        repository: Repository
    ) {
        self.repository = repository
    }
}

extension SearchManager: SUManagerSearch {

    public func searchWorkspaces(for userId: String, with name: String) async throws -> [SUShallowWorkspace] {
        try await repository.searchWorkspaces(for: userId, with: name)
    }

    public func searchDocuments(for userId: String, with name: String) async throws -> [SUShallowDocument] {
        try await repository.searchDocuments(for: userId, with: name)
    }
}
