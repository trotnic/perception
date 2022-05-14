//
//  RichiManager.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 14.05.22.
//

import Combine
import Foundation
import Network

public final class RichiManager: ObservableObject {

  public var isNetworkAvailable: AnyPublisher<Bool, Never> {
    _isNetworkAvailable.eraseToAnyPublisher()
  }

  public var isNetworkAvailableNow: Bool {
    monitor.currentPath.status == .satisfied
  }

  private let _isNetworkAvailable = CurrentValueSubject<Bool, Never>(false)
  private var disposeBag = Set<AnyCancellable>()

  private let monitor = NWPathMonitor()

  public init(queue: DispatchQueue = .main) {
    setupBindings(queue: queue)
  }
}

extension RichiManager: SUManagerRichi {}

private extension RichiManager {
  func setupBindings(queue: DispatchQueue) {
    monitor
      .publisher(queue: queue)
      .map {
        $0 == .satisfied
      }
      .replaceError(with: false)
      .sink(receiveValue: _isNetworkAvailable.send)
      .store(in: &disposeBag)
  }
}
