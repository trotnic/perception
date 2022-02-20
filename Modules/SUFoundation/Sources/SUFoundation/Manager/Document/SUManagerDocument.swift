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
    public init() {}
    public func loadDocument(id: String) async throws -> SUDocument {
        .init(meta: .empty, title: "", text: "")
    }
    public func writeDocument(id: String, text: String) async throws {}
    public func deleteDocument(id: String, workspaceId: String) async throws {}
}
