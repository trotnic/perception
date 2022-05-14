//
//  SUAppState.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 15.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import SwiftUIRouter
import SUFoundation
import Combine

public final class SUAppState {

  private var currentScreen: SUAppScreen = .none
  private var screenStack: [SUAppScreen] = []

  private let navigator: Navigator
  private let richiManager: SUManagerRichi

  private var disposeBag = Set<AnyCancellable>()

  public init(
    navigator: Navigator,
    richiManager: SUManagerRichi
  ) {
    self.navigator = navigator
    self.richiManager = richiManager
  }
}

extension SUAppState: SUAppStateProvider {

  public var isNetworkAvailable: AnyPublisher<Bool, Never> {
    richiManager.isNetworkAvailable
  }

  public var isNetworkAvailableNow: Bool {
    richiManager.isNetworkAvailableNow
  }

  public func change(route: SUAppScreen) {
    switch route {
      case .none:
        break
      case .back:
        navigator.goBack()
        screenStack.removeLast()
        currentScreen = screenStack.last!
      case .authentication:
        navigator.navigate("/authentication")
        screenStack.removeAll()
        currentScreen = .authentication
      case .account(let userMeta):
        navigator.navigate("/account/\(userMeta.id)")
        screenStack.append(.account(userMeta))
        currentScreen = .account(userMeta)
      case .space:
        navigator.navigate("/space")
        screenStack.append(.space)
        currentScreen = .space
      case .create:
        switch currentScreen {
          case .back, .create, .authentication, .account, .none, .search, .members, .invite, .invites, .draw, .recognize:
            fatalError("This should never happen")
          case .space:
            navigator.navigate("/space/create")
          case .read(let content):
            switch content {
              case .workspace(let workspaceMeta):
                navigator.navigate("/space/workspace/\(workspaceMeta.id)/create")
              case .document:
                break
            }
        }
        currentScreen = .create
        screenStack.append(.create)
      case .read(let content):
        switch currentScreen {
          case .none, .account, .authentication, .back, .members, .invite, .invites, .draw, .recognize:
            fatalError("This should never happen")
          case .read, .space, .search:
            switch content {
              case let .workspace(meta):
                navigator.navigate("/space/workspace/\(meta.id)")
              case let .document(meta):
                navigator.navigate("/space/workspace/\(meta.workspaceId)/document/\(meta.id)")
            }
          case .create:
            switch content {
              case let .workspace(meta):
                navigator.navigate("/space/workspace/\(meta.id)", replace: true)
              case let .document(meta):
                navigator.navigate("/space/workspace/\(meta.workspaceId)/document/\(meta.id)", replace: true)
            }
            screenStack.removeLast()
        }
        currentScreen = .read(content)
        screenStack.append(.read(content))
      case .draw(let meta):
        navigator.navigate("/space/workspace/\(meta.workspaceId)/document/\(meta.id)/draw")
        currentScreen = .draw(meta)
        screenStack.append(.draw(meta))
      case .recognize(let meta):
        navigator.navigate("/space/workspace/\(meta.workspaceId)/document/\(meta.id)/recognize")
        currentScreen = .recognize(meta)
        screenStack.append(.recognize(meta))
      case .search:
        navigator.navigate("/space/search")
        currentScreen = .search
        screenStack.append(.search)
      case .members(let meta):
        navigator.navigate("/space/workspace/\(meta.id)/members")
        currentScreen = .members(meta)
        screenStack.append(.members(meta))
      case .invite(let meta):
        navigator.navigate("/space/workspace/\(meta.id)/members/invite")
        currentScreen = .invite(meta)
        screenStack.append(.invite(meta))
      case .invites(let meta):
        navigator.navigate("/account/\(meta.id)/invites")
        currentScreen = .invites(meta)
        screenStack.append(.invites(meta))
    }
    SULogger.navigation.log("Changed route")
  }

  public func placeholderScreenAction() {
    switch currentScreen {
      case
          .authentication,
          .space:
        break
      default:
        navigator.navigate("/space")
        screenStack.removeAll()
        screenStack.append(.space)
        currentScreen = .space
    }
  }
}
