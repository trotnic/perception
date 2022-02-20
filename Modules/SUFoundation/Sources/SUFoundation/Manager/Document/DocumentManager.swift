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
        try await repository.document(with: id)
    }
}
