//
//  TemporaryFileManager.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 17.04.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public final class TemporaryFileManager {

  private enum Constants {
    static let temporaryFileKey = "temporaryFile"
  }

  private let userDefaults: UserDefaults
  private let fileManager: FileManager

  public init(
    userDefaults: UserDefaults,
    fileManager: FileManager
  ) {
    self.userDefaults = userDefaults
    self.fileManager = fileManager
  }
}

extension TemporaryFileManager: SUManagerTemporaryFile {
  public func storeTemporary(data: Data) throws {
    guard
      let temporaryDirectoryURL = fileManager.urls(
        for: .documentDirectory,
           in: .userDomainMask
      ).first
    else {
      return
    }
    let filename = UUID().uuidString
    let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent(filename)
    try data.write(to: temporaryFileURL)
    userDefaults.set(temporaryFileURL, forKey: Constants.temporaryFileKey)
  }

  public func retrieveTemporaryData() throws -> Data? {
    guard
      let temporaryFileURL = userDefaults.url(forKey: Constants.temporaryFileKey)
    else {
      return nil
    }
    return try Data(contentsOf: temporaryFileURL)
  }

  public func deleteTemporaryData() throws {
    guard
      let temporaryFileURL = userDefaults.url(forKey: Constants.temporaryFileKey)
    else {
      return
    }
    try fileManager.removeItem(at: temporaryFileURL)
  }
}
