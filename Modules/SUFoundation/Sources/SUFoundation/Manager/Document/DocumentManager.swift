//
//  DocumentManager.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 20.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine
import Foundation

public final class DocumentManager {

  public let document = CurrentValueSubject<SUDocument, Never>(.empty)
  private let repository: Repository

  public init(
    repository: Repository
  ) {
    self.repository = repository
  }

  deinit {
    repository.stopListen(with: document.value.meta.id)
  }
}

// MARK: - SUManagerDocument

extension DocumentManager: SUManagerDocument {

  public func observe(documentId: String) {
    repository.startListenDocument(documentId: documentId) { document in
      self.document.value = document
    }
  }

  public func loadDocument(id: String) async throws -> SUDocument {
    try await repository.document(with: id)
  }

  public func updateTitle(
    documentId: String,
    text: String
  ) async throws {
    try await repository.updateDocument(
      documentId: documentId,
      updateSubject: .title(text: text)
    )
  }

  public func updateEmoji(
    documentId: String,
    text: String
  ) async throws {
    try await repository.updateDocument(
      documentId: documentId,
      updateSubject: .emoji(text: text)
    )
  }

  public func updateText(
    documentId: String,
    textBlockId: String,
    text: String
  ) async throws {
    try await repository.updateDocument(
      documentId: documentId,
      updateSubject: .block(
        SUDocumentBlock(
          id: textBlockId,
          type: .text,
          content: text,
          dateCreated: .now
        )
      )
    )
  }

  public func insertImage(
    documentId: String,
    imageData: Data
  ) async throws {
    try await repository.insertImageIntoDocument(
      with: documentId,
      imageData: imageData
    )
  }

  public func insertText(
    documentId: String,
    text: String
  ) async throws {
    try await repository.insertTextIntoDocument(
      with: documentId,
      text: text
    )
  }

  public func deleteBlock(
    documentId: String,
    blockId: String
  ) async throws {
    try await repository.deleteBlock(
      documentId: documentId,
      blockId: blockId
    )
  }

  public func updateDocument(id: String, title: String) async throws {
    try await repository.updateDocument(with: id, title: title)
  }

  public func updateDocument(id: String, emoji: String) async throws {
    try await repository.updateDocument(with: id, emoji: emoji)
  }

  public func updateDocument(id: String, text: String) async throws {
    try await repository.updateDocument(with: id, text: text)
  }

  public func deleteDocument(id: String, workspaceId: String) async throws {
    try await repository.deleteDocument(with: id, in: workspaceId)
  }
}
