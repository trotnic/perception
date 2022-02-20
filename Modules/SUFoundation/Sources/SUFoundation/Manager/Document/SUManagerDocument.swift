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
}

public struct SUManagerDocumentMock: SUManagerDocument {
    public init() {}
    public func loadDocument(id: String) async throws -> SUDocument {
        .init(meta: .empty, title: "", text: "")
    }
}
