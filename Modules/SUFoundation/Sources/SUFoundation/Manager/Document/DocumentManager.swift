//
//  DocumentManager.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 20.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public final class DocumentManager {

    private let repository: Repository

    public init(repository: Repository) {
        self.repository = repository
    }
}

// MARK: - SUManagerDocument

extension DocumentManager: SUManagerDocument {

    public func loadDocument(id: String) async throws -> SUDocument {
        return try await repository.document(with: id)
    }

    public func writeDocument(id: String, text: String) async throws {
        try await repository.updateDocument(with: id, text: text)
    }

    public func deleteDocument(id: String, workspaceId: String) async throws {
        try await repository.deleteDocument(with: id, in: workspaceId)
    }
}
