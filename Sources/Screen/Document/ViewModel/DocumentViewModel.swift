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

    public let id: UUID = UUID()
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

  func drawingAction() {
    appState.change(route: .draw(documentMeta))
  }

  func insertImageAction(data: Data?) {
    guard let data = data else {
      return
    }
    Task {
      try await documentManager.insertImage(
        documentId: documentMeta.id,
        imageData: data
      )
    }
  }

  // TODO: Move to a separate service
  func insertTextFromImageAction(cgImage: CGImage) {
    Task {
      let requestHandler = VNImageRequestHandler(cgImage: cgImage)

      // Create a new request to recognize text.
      let request = VNRecognizeTextRequest { request, error in
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
                  return
                }
        let recognizedStrings = observations.compactMap { observation in
          // Return the string of the top VNRecognizedText instance.
          return observation.topCandidates(1).first?.string
        }
        
        Task {
          try await self.documentManager.insertText(
            documentId: self.documentMeta.id,
            text: recognizedStrings.joined(separator: " ")
          )
        }
//        print(recognizedStrings)
        // Process the recognized strings.
//        processResults(recognizedStrings)
      }

      do {
          // Perform the text-recognition request.
          try requestHandler.perform([request])
      } catch {
          print("Unable to perform the requests: \(error).")
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
