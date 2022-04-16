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

  func updateTitle(documentId: String, text: String) async throws
  func updateEmoji(documentId: String, text: String) async throws
  func updateText(documentId: String, textBlockId: String, text: String) async throws

  func insertImage(documentId: String, imageData: Data) async throws
//  func update(documentId: String, transactionType: SUDocumentUpdateSubject)
  func updateDocument(id: String, title: String) async throws
  func updateDocument(id: String, emoji: String) async throws
  func updateDocument(id: String, text: String) async throws

  func deleteDocument(id: String, workspaceId: String) async throws
}

public enum SUDocumentUpdateSubject {
  case title(text: String)
  case emoji(text: String)
  case block(SUDocumentBlock)
}

public struct SUDocumentBlock {
  public enum BlockType {
    case text
    case image

    public init(type: Int) {
      switch type {
        case 0:
          self = .text
        case 1:
          self = .image
        default:
          fatalError()
      }
    }
  }

  public let id: String
  public let type: BlockType
  public let content: String
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
      emoji: emojiCallback(),
      dateCreated: .now,
      dateEdited: .now,
      items: []
    )
  }

  public func loadDocument(id: String) async throws -> SUDocument {
    SUDocument(
      meta: metaCallback(),
      ownerId: ownerIdCallback(),
      title: titleCallback(),
      emoji: emojiCallback(),
      dateCreated: .now,
      dateEdited: .now,
      items: []
    )
  }

  public func updateTitle(documentId: String, text: String) async throws {}
  public func updateEmoji(documentId: String, text: String) async throws {}
  public func updateText(documentId: String, textBlockId: String, text: String) async throws {}
  public func insertImage(documentId: String, imageData: Data) async throws {}
  public func updateDocument(id: String, title: String) async throws {}
  public func updateDocument(id: String, emoji: String) async throws {}
  public func updateDocument(id: String, text: String) async throws {}
  public func deleteDocument(id: String, workspaceId: String) async throws {}
}
