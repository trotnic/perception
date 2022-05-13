//
//  DrawingScreenViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 16.04.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

#if os(iOS)
import Foundation
import SUFoundation
import PencilKit

public final class DrawingScreenViewModel: ObservableObject {

  @Published public var drawing = PKDrawing()
  private let appState: SUAppStateProvider
  private let documentManager: SUManagerDocument
  private let documentMeta: SUDocumentMeta

  public init(
    appState: SUAppStateProvider,
    documentManager: SUManagerDocument,
    documentMeta: SUDocumentMeta
  ) {
    self.appState = appState
    self.documentManager = documentManager
    self.documentMeta = documentMeta
  }
}

public extension DrawingScreenViewModel {

  func backAction() {
    appState.change(route: .back)
  }

  func saveDrawingAction(data: Data) async throws {
    try await documentManager.insertImage(documentId: documentMeta.id, imageData: data)
    appState.change(route: .back)
  }
}
#endif
