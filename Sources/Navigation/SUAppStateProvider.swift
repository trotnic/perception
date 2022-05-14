//
//  SUAppStateProvider.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 12.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine
import SUFoundation

public protocol SUAppStateProvider: SUManagerRichi {
  func change(route: SUAppScreen)
  func placeholderScreenAction()
}

public enum SUAppScreen {
  case none
  case back
  case authentication
  case account(SUUserMeta)
  case space
  case create
  case read(SUAppScreenContent)
  case search
  case draw(SUDocumentMeta)
  case recognize(SUDocumentMeta)
  case members(SUWorkspaceMeta)
  case invite(SUWorkspaceMeta)
  case invites(SUUserMeta)
}

public enum SUAppIntention {
  case create
  case read(String)
}

public enum SUAppScreenContent {
  case workspace(SUWorkspaceMeta)
  case document(SUDocumentMeta)
}

public struct SUAppStateProviderMock: SUAppStateProvider {
  public var isNetworkAvailable: AnyPublisher<Bool, Never> { Just(true).eraseToAnyPublisher() }
  public var isNetworkAvailableNow: Bool { true }
  public func change(route: SUAppScreen) {}
  public func placeholderScreenAction() {}
}
