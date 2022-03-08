//
//  SUManagerDocument.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 20.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine
import Foundation

public protocol SUManagerDocument {

    var document: CurrentValueSubject<SUDocument, Never> { get }

    func observe(documentId: String)
    func loadDocument(id: String) async throws -> SUDocument

    func updateDocument(id: String, title: String) async throws
    func updateDocument(id: String, emoji: String) async throws
    func updateDocument(id: String, text: String) async throws

    func deleteDocument(id: String, workspaceId: String) async throws
}

public struct SUManagerDocumentMock: SUManagerDocument {

    public private(set) var document = CurrentValueSubject<SUDocument, Never>(.empty)

    private let metaCallback: () -> SUDocumentMeta
    private let ownerIdCallback: () -> String
    private let titleCallback: () -> String
    private let textCallback: () -> String
    private let emojiCallback: () -> String

    public init(
        meta: @escaping () -> SUDocumentMeta = { .empty },
        ownerId: @escaping () -> String = { .empty },
        title: @escaping () -> String = { .empty },
        text: @escaping () -> String = { .empty },
        emoji: @escaping () -> String = { "🔥" }
    ) {
        self.metaCallback = meta
        self.ownerIdCallback = ownerId
        self.titleCallback = title
        self.textCallback = text
        self.emojiCallback = emoji
    }

    public func observe(documentId: String) {
        document.value = SUDocument(
            meta: metaCallback(),
            ownerId: ownerIdCallback(),
            title: titleCallback(),
            text: textCallback(),
            emoji: emojiCallback()
        )
    }
    public func loadDocument(id: String) async throws -> SUDocument {
        SUDocument(
            meta: metaCallback(),
            ownerId: ownerIdCallback(),
            title: titleCallback(),
            text: textCallback(),
            emoji: emojiCallback()
        )
    }
    public func updateDocument(id: String, title: String) async throws {}
    public func updateDocument(id: String, emoji: String) async throws {}
    public func updateDocument(id: String, text: String) async throws {}
    public func deleteDocument(id: String, workspaceId: String) async throws {}
}
