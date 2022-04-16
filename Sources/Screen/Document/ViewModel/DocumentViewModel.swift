//
//  DocumentViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 29.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine
import Foundation
import SUFoundation

public final class DocumentViewModel: ObservableObject {

  @Published public var emoji: String = .empty
  @Published public var title: String = .empty
  @Published public var description: String = .empty
  @Published public var text: String = .empty

  private let appState: SUAppStateProvider
  private let documentManager: SUManagerDocument
  private let documentMeta: SUDocumentMeta

  @Published public private(set) var items: [DocumentBlock] = []

  private var disposeBag = Set<AnyCancellable>()
  private var debouncerText = PassthroughSubject<(String, String), Never>()

  public init(
    appState: SUAppStateProvider,
    documentManager: SUManagerDocument,
    documentMeta: SUDocumentMeta
  ) {
    self.appState = appState
    self.documentManager = documentManager
    self.documentMeta = documentMeta

    setupBindings()
  }
}

public extension DocumentViewModel {

  struct DocumentBlock: Identifiable {
    public enum BlockType {
      case text
      case image
    }

    public let id: String = UUID().uuidString
    public let content: String
    public let type: BlockType
    public let action: (String) -> Void
  }
}

// MARK: - Public interface

public extension DocumentViewModel {

  func load() {
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
}

// MARK: - Private interface

private extension DocumentViewModel {

  func setupBindings() {
    documentManager
      .document
    //            .drop(while: { $0 == SUDocument.empty })
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [self] document in
        title = document.title
        emoji = document.emoji
        items = document.items.map { block in
          switch block.type {
            case .image:
              return DocumentBlock(
                content: block.content,
                type: .image,
                action: { _ in }
              )
            case .text:
              return DocumentBlock(
                content: block.content,
                type: .text,
                action: { text in
                  debouncerText.send((block.id, text))
                }
              )
          }
        }
      })
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
      .debounce(for: 2.0, scheduler: DispatchQueue.main)
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
