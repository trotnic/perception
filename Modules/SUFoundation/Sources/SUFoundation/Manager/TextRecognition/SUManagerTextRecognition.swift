//
//  SUManagerTextRecognition.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 28.04.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import CoreImage

public protocol SUManagerTextRecognition {
  func process(cgImage: CGImage, rect: CGRect) async throws -> ([String], [CGRect])
}

public struct SUManagerTextRecognitionMock {
  public init() {}
}

extension SUManagerTextRecognitionMock: SUManagerTextRecognition {
  public func process(cgImage: CGImage, rect: CGRect) async throws -> ([String], [CGRect]) { ([], []) }
}
