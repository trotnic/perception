//
//  RootViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 3.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine
import Foundation
import SUFoundation

public final class RootViewModel: ObservableObject {

  private let appState: SUAppStateProvider
  private let userManager: SUManagerSession

  @Published var showNetworkAlert: Bool = false

  private var disposeBag = Set<AnyCancellable>()

  public init(
    appState: SUAppStateProvider,
    userManager: SUManagerSession
  ) {
    self.appState = appState
    self.userManager = userManager

    setupBdingins()
  }
}

// MARK: - Public interface

public extension RootViewModel {

  func startAction() {
    appState.change(route: userManager.isAuthenticated ? .space : .authentication)
  }

  func alertAction() {
    appState.placeholderScreenAction()
  }
}

// MARK: - Private interface

private extension RootViewModel {

  func setupBdingins() {
    appState
      .isNetworkAvailable
      .map(!)
      .assign(to: &$showNetworkAlert)
  }
}
