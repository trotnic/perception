//
//  WorkspaceViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 13.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import Combine
import SUFoundation

public final class WorkspaceViewModel: ObservableObject {

  @Published public var title: String = .empty
  @Published public var emoji: String = .empty

  @Published public private(set) var membersCount: Int = .zero
  @Published public private(set) var documentsCount: Int = .zero

  @Published public private(set) var isDeleteActionAvailable: Bool = false

  @Published public private(set) var viewItems: [ListItem] = []

  private let appState: SUAppStateProvider
  private let workspaceManager: SUManagerWorkspace
  private let sessionManager: SUManagerUserIdentifiable
  private let workspaceMeta: SUWorkspaceMeta

  private var disposeBag = Set<AnyCancellable>()

  public init(
    appState: SUAppStateProvider,
    workspaceManager: SUManagerWorkspace,
    sessionManager: SUManagerUserIdentifiable,
    workspaceMeta: SUWorkspaceMeta
  ) {
    self.appState = appState
    self.workspaceManager = workspaceManager
    self.sessionManager = sessionManager
    self.workspaceMeta = workspaceMeta

    setupBindings()
  }
}

// MARK: - Public actions

public extension WorkspaceViewModel {

  func loadAction() {
    workspaceManager.observe(workspaceId: workspaceMeta.id)
  }

  func backAction() {
    appState.change(route: .back)
  }

  func createAction() {
    appState.change(route: .create)
  }

  func deleteAction() {
    Task {
      try await workspaceManager.deleteWorkspace(
        id: workspaceMeta.id,
        userId: sessionManager.userId
      )
      await MainActor.run {
        appState.change(route: .space)
      }
    }
  }
}

// MARK: - Public types

public extension WorkspaceViewModel {

  struct ListItem: Identifiable {
    public let id = UUID()
    public let title: String
    public let emoji: String
    public let badges: [Badge]
    public let action: () -> Void

    init(
      title: String,
      emoji: String,
      badges: [Badge],
      action: @autoclosure @escaping () -> Void
    ) {
      self.title = title
      self.emoji = emoji
      self.badges = badges
      self.action = action
    }
  }

  struct Badge {
    public enum BadgeType {
      case dateCreated
    }

    public let title: String
    public let type: BadgeType
  }
}

// MARK: - Private interface

private extension WorkspaceViewModel {

  func setupBindings() {
    workspaceManager
      .workspace
      .receive(on: DispatchQueue.main)
      .sink { [self] workspace in
        title = workspace.title
        emoji = workspace.emoji
        membersCount = workspace.membersCount
        documentsCount = workspace.documents.count
        viewItems = workspace.documents.map { document in
          ListItem(
            title: document.title,
            emoji: document.emoji,
            badges: [
              Badge(
                title: document.dateCreated.formatted(date: .numeric, time: .shortened),
                type: .dateCreated
              )
            ],
            action: self.selectItem(id: document.meta.id)
          )
        }
      }
      .store(in: &disposeBag)

    $title
      .drop(while: \.isEmpty)
      .debounce(for: 1.0, scheduler: DispatchQueue.main)
      .sink { [self] value in
        Task {
          do {
            try await workspaceManager.updateWorkspace(
              id: workspaceMeta.id,
              title: value
            )
          } catch {

          }
        }
      }
      .store(in: &disposeBag)

    $emoji
      .drop(while: { $0 == self.workspaceManager.workspace.value.emoji })
      .debounce(for: 1.0, scheduler: DispatchQueue.main)
      .sink { [self] value in
        Task {
          do {
            try await workspaceManager.updateWorkspace(
              id: workspaceMeta.id,
              emoji: value
            )
          } catch {
            // TODO: Error Handling
          }
        }
      }
      .store(in: &disposeBag)

    workspaceManager
      .workspace
      .map { [self] workspace in workspace.ownerId == sessionManager.userId }
      .assign(to: &$isDeleteActionAvailable)
  }
}

// MARK: - Private actions

private extension WorkspaceViewModel {

  func selectItem(id: String) {
    let documentMeta = SUDocumentMeta(
      id: id,
      workspaceId: workspaceMeta.id
    )
    appState.change(route: .read(.document(documentMeta)))
  }
}
