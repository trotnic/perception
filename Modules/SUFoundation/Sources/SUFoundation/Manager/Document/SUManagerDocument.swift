//
//  SUManagerDocument.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 20.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public protocol SUManagerDocument {
    func loadDocument(id: String) async throws -> SUDocument
    func writeDocument(id: String, text: String) async throws
    func deleteDocument(id: String, workspaceId: String) async throws
}

public struct SUManagerDocumentMock: SUManagerDocument {

    private let meta: () -> SUDocumentMeta
    private let title: () -> String
    private let text: () -> String

    public init(
        meta: @escaping () -> SUDocumentMeta = { .empty },
        title: @escaping () -> String = { .empty },
        text: @escaping () -> String = { .empty }
    ) {
        self.meta = meta
        self.title = title
        self.text = text
    }

    public func loadDocument(id: String) async throws -> SUDocument {
        SUDocument(
            meta: meta(),
            title: title(),
            text: text()
        )
    }
    public func writeDocument(id: String, text: String) async throws {}
    public func deleteDocument(id: String, workspaceId: String) async throws {}
}
