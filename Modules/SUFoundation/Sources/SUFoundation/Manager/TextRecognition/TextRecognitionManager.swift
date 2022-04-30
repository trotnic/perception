//
//  TextRecognitionManager.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 28.04.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import Vision

public final class TextRecognitionManager {

  public init() {}
}

extension TextRecognitionManager: SUManagerTextRecognition {
  public func process(
    cgImage: CGImage,
    rect: CGRect
  ) async -> ([String], [CGRect]) {
    await withCheckedContinuation { continuation in
      process(
        cgImage: cgImage,
        rect: rect
      ) { strings, rects in
        continuation.resume(returning: (strings, rects))
      }
    }
  }
}

private extension TextRecognitionManager {
  func process(
    cgImage: CGImage,
    rect: CGRect,
    completion: @escaping ([String], [CGRect]) -> Void
  ) {
    let requestHandler = VNImageRequestHandler(cgImage: cgImage)
    let request = VNRecognizeTextRequest { request, error in
      guard
        let observations = request.results as? [VNRecognizedTextObservation]
      else {
        return
      }
      let recognizedString = observations.compactMap { observation in
        observation.topCandidates(1).first?.string
      }
        //.joined(separator: " ")

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
          Int(rect.size.width),
          Int(rect.size.height)
        )
      }
      completion(recognizedString, boundingRects)
//      Task {
//        await MainActor.run {
//          self.recognizedBoxes = boundingRects
//          self.recognizedString = recognizedString
//        }
//      }
    }
    do {
      try requestHandler.perform([request])
    } catch {
      // TODO: Error handling
    }
  }
}
