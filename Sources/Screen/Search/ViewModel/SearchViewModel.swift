//
//  SearchViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 6.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine
import Foundation
import SUFoundation

public final class SearchViewModel: ObservableObject {

  @Published public private(set) var items: [ListItem] = []
  @Published public var searchQuery: String = ""

  @Published public var searchMode: SearchMode = .workspaces

  private let appState: SUAppStateProvider
  private let searchManager: SUManagerSearch
  private let sessionManager: SUManagerUserIdentifiable

  private var disposeBag = Set<AnyCancellable>()

  public init(
    appState: SUAppStateProvider,
    searchManager: SUManagerSearch,
    sessionManager: SUManagerUserIdentifiable
  ) {
    self.appState = appState
    self.searchManager = searchManager
    self.sessionManager = sessionManager

    setupBindings()
  }
}

// MARK: - Public interface

public extension SearchViewModel {

  func backAction() {
    appState.change(route: .back)
  }

  func readAction(id: String) {
    switch searchMode {
      case .workspaces:
        appState.change(route: .read(.workspace(SUWorkspaceMeta(id: id))))
      case .documents:
        break
    }
  }
}

public extension SearchViewModel {

  struct ListItem: Identifiable {
    public let id: String
    public let title: String
    public let emoji: String
  }

  enum SearchMode: Int {
    case workspaces
    case documents
  }
}

// MARK: - Private interface

private extension SearchViewModel {

  func setupBindings() {
    $searchQuery
      .drop(while: (\.isEmpty))
      .debounce(for: 2.0, scheduler: DispatchQueue.main)
      .sink { [self] query in
        Task {
          do {
            switch searchMode {
              case .workspaces:
                let result = try await searchManager.searchWorkspaces(
                  for: sessionManager.userId,
                  with: query
                )
                await MainActor.run {
                  items = result.map { ListItem(
                    id: $0.meta.id,
                    title: $0.title,
                    emoji: "🔥"
                  )
                  }
                }
              case .documents:
                let result = try await searchManager.searchDocuments(
                  for: sessionManager.userId,
                  with: query
                )
                await MainActor.run {
                  items = result.map { ListItem(
                    id: $0.meta.id,
                    title: $0.title,
                    emoji: "🔥"
                  )
                  }
                }
            }
          } catch {

          }
        }
      }
      .store(in: &disposeBag)
  }
}
