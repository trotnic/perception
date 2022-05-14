//
//  SpaceViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 9.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine
import Foundation
import SUFoundation

public final class SpaceViewModel: ObservableObject {

  private enum LoadingState {
    case inProgress
    case finished
  }

  @Published public private(set) var isContentLoaded: Bool = false
  @Published public private(set) var items: [ListItem] = []
  @Published public private(set) var isSpaceEmpty: Bool = false

  @Published public private(set) var shouldShowPlaceholder: Bool = false
  @Published public private(set) var isLoading: Bool = true

  private let loadingState = CurrentValueSubject<LoadingState, Never>(.inProgress)

  private var disposeBag = Set<AnyCancellable>()

  private let appState: SUAppStateProvider
  private let spaceManager: SUManagerSpace
  private let sessionManager: SUManagerUserIdentifiable

  public init(
    appState: SUAppStateProvider,
    spaceManager: SUManagerSpace,
    sessionManager: SUManagerUserIdentifiable
  ) {
    self.appState = appState
    self.spaceManager = spaceManager
    self.sessionManager = sessionManager

    setupBindings()
  }
}

// MARK: - Public interface

public extension SpaceViewModel {

  func loadAction() {
    spaceManager.observe(for: sessionManager.userId)
  }

  func createAction() {
    appState.change(route: .create)
  }
}

public extension SpaceViewModel {

  struct ListItem: Identifiable {
    public let id = UUID()
    public let index: Int
    public let title: String
    public let emoji: String
    public let badges: [Badge]
    public let action: () -> Void
  }

  struct Badge {
    public enum BadgeType {
      case members
      case dateCreated
      case documents
    }

    public let title: String
    public let type: BadgeType
  }
}

// MARK: - Private interface

private extension SpaceViewModel {

  func setupBindings() {

    Publishers
      .CombineLatest(
        spaceManager.workspaces,
        appState.isNetworkAvailable
      )
      .dropFirst()
      .drop(while: { !$1 })
      .map(\.0)
      .map { workspaces in
        workspaces.enumerated().map { item in
          ListItem(
            index: item.offset,
            title: item.element.title,
            emoji: item.element.emoji,
            badges: [
              Badge(title: "\(item.element.membersCount) members", type: .members),
              Badge(title: "\(item.element.documentsCount) documents", type: .documents)
            ],
            action: { self.selectItem(id: item.element.meta.id) }
          )
        }
      }
      .handleEvents(receiveOutput: { _ in
        self.loadingState.value = .finished
      })
      .receive(on: DispatchQueue.main)
      .assign(to: &$items)

    $items
      .map(\.isEmpty)
      .removeDuplicates()
      .combineLatest($isLoading)
      .map { $0 && !$1 }
      .assign(to: &$shouldShowPlaceholder)

    loadingState
      .replaceError(with: .inProgress)
      .combineLatest(appState.isNetworkAvailable)
      .map { $1 ? $0 : .inProgress }
      .receive(on: DispatchQueue.main)
      .sink {
        self.isLoading = $0 == .inProgress
      }
      .store(in: &disposeBag)
  }

  func selectItem(id: String) {
    appState.change(route: .read(.workspace(SUWorkspaceMeta(id: id))))
  }
}
