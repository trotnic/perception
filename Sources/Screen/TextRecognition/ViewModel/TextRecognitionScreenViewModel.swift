//
//  TextRecognitionScreenViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 17.04.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Vision
import Foundation
import SUFoundation
import UIKit

public final class TextRecognitionScreenViewModel: ObservableObject {

  @Published public var imageFrame: CGRect = .zero

  @Published public private(set) var image: UIImage?
  @Published public private(set) var recognizedBoxes: [CGRect] = []
  @Published public private(set) var recognizedString: String = .empty

  private let appState: SUAppStateProvider
  private let documentManager: SUManagerDocument
  private let temporaryFileManager: SUManagerTemporaryFile
  private let documentMeta: SUDocumentMeta

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
  }
}

public extension TextRecognitionScreenViewModel {
  func backAction() {
    appState.change(route: .back)
  }

  func loadAction() {
    Task {
      guard
        let data = try? temporaryFileManager.retrieveTemporaryData(),
        let image = UIImage(data: data),
        let cgImage = image.cgImage
      else {
        return
      }
      await MainActor.run {
        self.image = image
      }
      recognize(cgImage: cgImage)
    }
  }

  func cleanUpAction() {
    Task {
      try temporaryFileManager.deleteTemporaryData()
    }
  }

  func saveAction() {
    Task {
      try await documentManager.insertText(
        documentId: documentMeta.id,
        text: recognizedString
      )
      await MainActor.run {
        appState.change(route: .back)
      }
    }
  }

  func recognize(cgImage: CGImage) {
    Task {
      let requestHandler = VNImageRequestHandler(cgImage: cgImage)
      let request = VNRecognizeTextRequest { request, error in
        guard
          let observations = request.results as? [VNRecognizedTextObservation]
        else {
          return
        }

        let recognizedString = observations.compactMap { observation in
          observation.topCandidates(1).first?.string
        }.joined(separator: " ")

        let boundingRects: [CGRect] = observations.compactMap { observation in
          guard let candidate = observation.topCandidates(1).first else { return .zero }

          let stringRange = candidate.string.startIndex..<candidate.string.endIndex
          let boxObservation = try? candidate.boundingBox(for: stringRange)

          let boundingBox = (boxObservation?.boundingBox ?? .zero)
            .applying(
              CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -1)
            )

          return VNImageRectForNormalizedRect(
            boundingBox,
            Int(self.imageFrame.size.width),
            Int(self.imageFrame.size.height)
          )
        }

        Task {
          await MainActor.run {
            self.recognizedBoxes = boundingRects
            self.recognizedString = recognizedString
          }
        }
      }

      do {
          try requestHandler.perform([request])
      } catch {
          print("Unable to perform the requests: \(error).")
      }
    }
  }
}
