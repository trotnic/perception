//
//  SUManagerTemporaryFile.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 17.04.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public protocol SUManagerTemporaryFile {
  func storeTemporary(data: Data) throws
  func retrieveTemporaryData() throws -> Data?
  func deleteTemporaryData() throws
}

public struct SUManagerTemporaryFileMock {
  public init() {}
}

extension SUManagerTemporaryFileMock: SUManagerTemporaryFile {
  public func storeTemporary(data: Data) throws {}
  public func retrieveTemporaryData() throws -> Data? { nil }
  public func deleteTemporaryData() throws {}
}
