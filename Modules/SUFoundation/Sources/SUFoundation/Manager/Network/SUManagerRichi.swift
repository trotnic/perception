//
//  SURichiManager.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 14.05.22.
//

import Combine
import Foundation

public protocol SUManagerRichi {
  var isNetworkAvailable: AnyPublisher<Bool, Never> { get }

  var isNetworkAvailableNow: Bool { get }
}

public struct SUManagerRichiMock: SUManagerRichi {
  public var isNetworkAvailable: AnyPublisher<Bool, Never> {
    Just(true).eraseToAnyPublisher()
  }

  public var isNetworkAvailableNow: Bool { true }
}
