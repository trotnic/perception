//
//  DocumentViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 29.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine
import CoreGraphics
import Vision
import Foundation
import SUFoundation

public final class DocumentViewModel: ObservableObject {

  @Published public var emoji: String = .empty
  @Published public var title: String = .empty
  @Published public var description: String = .empty
  @Published public var text: String = .empty

  private let appState: SUAppStateProvider
  private let documentManager: SUManagerDocument
  private let temporaryFileManager: SUManagerTemporaryFile
  private let documentMeta: SUDocumentMeta

  @Published public private(set) var items: [DocumentBlockRef] = []

  private var disposeBag = Set<AnyCancellable>()
  private var debouncerText = PassthroughSubject<(String, String), Never>()

  public init(
    appState: SUAppStateProvider,
    documentManager: SUManagerDocument,
    temporaryFileManager: SUManagerTemporaryFile,
    documentMeta: SUDocumentMeta
  ) {
    self.appState = appState
    self.documentManager = documentManager
    self.temporaryFileManager = temporaryFileManager
    self.documentMeta = documentMeta

    setupBindings()
  }
}

public extension DocumentViewModel {

  final class DocumentBlockRef: Identifiable {
    public enum BlockType {
      case text
      case image
    }

    @Published var content: String

    public let id: String
    public let type: BlockType
    public let deleteAction: () -> Void
    private let commitAction: (String) -> Void

    private var disposeBag = Set<AnyCancellable>()

    public init(
      id: String,
      content: String,
      type: BlockType,
      onDelete: @escaping () -> Void,
      onCommit: @escaping (String) -> Void
    ) {
      self.id = id
      self.content = content
      self.type = type
      deleteAction = onDelete
      commitAction = onCommit

      $content
        .throttle(for: 1.5, scheduler: DispatchQueue.main, latest: true)
//        .last()
//        .receive(on: DispatchQueue.global())
        .sink { value in
          onCommit(value)
        }
        .store(in: &disposeBag)
    }
  }

  struct DocumentBlock: Identifiable {
    public enum BlockType {
      case text
      case image
    }

    public let id: String
    public let content: String
    public let type: BlockType
    public let action: (String) -> Void
    public let deleteAction: () -> Void
  }
}

// MARK: - Public interface

public extension DocumentViewModel {

  func start() {
    documentManager.observe(documentId: documentMeta.id)
  }

  func backAction() {
    appState.change(route: .back)
  }

  func deleteAction() {
    Task {
      try await documentManager.deleteDocument(
        id: documentMeta.id,
        workspaceId: documentMeta.workspaceId
      )
      await MainActor.run {
        appState.change(route: .back)
      }
    }
  }

  func drawingAction() {
    appState.change(route: .draw(documentMeta))
  }

  func insertImageAction(data: Data?) {
    guard let data = data else { return }
    Task {
      try await documentManager.insertImage(
        documentId: documentMeta.id,
        imageData: data
      )
    }
  }

  func startTextFromImageRecognition(data: Data) {
    Task {
      try temporaryFileManager.storeTemporary(data: data)
      await MainActor.run {
        appState.change(route: .recognize(documentMeta))
      }
    }
  }

  func pasteTextBlock() {
    Task {
      try await documentManager.insertText(
        documentId: documentMeta.id,
        text: "a"
      )
    }
  }
}

// MARK: - Private interface

private extension DocumentViewModel {

  func setupBindings() {
    documentManager
      .document
      .receive(on: DispatchQueue.main)
      .sink { [self] document in
        title = document.title
        emoji = document.emoji
        if items.isEmpty {
          items = document.items.map { block in
            switch block.type {
              case .image:
                return DocumentBlockRef(
                  id: block.id,
                  content: block.content,
                  type: .image,
                  onDelete: { [self] in
                    Task {
                      try await documentManager.deleteBlock(
                        documentId: documentMeta.id,
                        blockId: block.id
                      )
                    }
                  },
                  onCommit: { _ in }
                )
              case .text:
                return DocumentBlockRef(
                  id: block.id,
                  content: block.content,
                  type: .text,
                  onDelete: { [self] in
                    Task {
                      try await documentManager.deleteBlock(
                        documentId: documentMeta.id,
                        blockId: block.id
                      )
                    }
                  },
                  onCommit: { [self] text in
                    debouncerText.send((block.id, text))
                  }
                )
            }
          }
        } else {
          document.items.forEach { block in
            if
              let item = items.first(where: { $0.id == block.id })
            {
              if item.content != block.content {
                item.content = block.content
              }
            } else {
              items.append(
                DocumentBlockRef(
                  id: block.id,
                  content: block.content,
                  type: block.type == .image ? .image : .text,
                  onDelete: { [self] in
                    Task {
                      try await documentManager.deleteBlock(
                        documentId: documentMeta.id,
                        blockId: block.id
                      )
                    }
                  },
                  onCommit: { [self] text in
                    debouncerText.send((block.id, text))
                  }
                )
              )
            }
          }
          let initial = Set(document.items.map(\.id))
          let result = Set(items.map(\.id))
          result.subtracting(initial)
            .forEach { id in
              items.removeAll(where: { $0.id == id })
            }
        }
      }
      .store(in: &disposeBag)

    $title
      .removeDuplicates()
      .drop(while: { $0 == self.documentManager.document.value.title })
      .debounce(for: 1.5, scheduler: DispatchQueue.main)
      .receive(on: DispatchQueue.global(qos: .userInitiated))
      .sink { [self] value in
        Task {
          try await documentManager.updateTitle(
            documentId: documentMeta.id,
            text: value
          )
        }
      }
      .store(in: &disposeBag)

    $emoji
      .removeDuplicates()
      .drop(while: { $0 == self.documentManager.document.value.emoji })
      .debounce(for: 1.5, scheduler: DispatchQueue.main)
      .receive(on: DispatchQueue.global(qos: .userInitiated))
      .sink { [self] value in
        Task {
          try await documentManager.updateEmoji(
            documentId: documentMeta.id,
            text: value
          )
        }
      }
      .store(in: &disposeBag)

    debouncerText
//      .debounce(for: 2.0, scheduler: DispatchQueue.main)
      .receive(on: DispatchQueue.global(qos: .userInitiated))
      .sink { value in
        Task {
          try await self.documentManager.updateText(
            documentId: self.documentMeta.id,
            textBlockId: value.0,
            text: value.1
          )
        }
      }
      .store(in: &disposeBag)
  }
}
