//
//  WorkspaceCreateViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 23.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import SUFoundation

public final class WorkspaceCreateViewModel: ObservableObject {

  @Published public var name: String = .empty
  @Published public var isCreateButtonActive: Bool = false

  private let appState: SUAppStateProvider
  private let workspaceManager: SUManagerWorkspace
  private let sessionManager: SUManagerUserIdentifiable
  private let workspaceMeta: SUWorkspaceMeta

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

public extension WorkspaceCreateViewModel {

  func backAction() {
    appState.change(route: .back)
  }

  func createAction() {
    Task {
      let documentId = try await workspaceManager.createDocument(
        title: name,
        workspaceId: workspaceMeta.id,
        userId: sessionManager.userId
      )
      await MainActor.run {
        appState.change(route: .read(.document(SUDocumentMeta(id: documentId, workspaceId: workspaceMeta.id))))
      }
    }
  }
}

private extension WorkspaceCreateViewModel {

  // TODO: 25 characters check
  func setupBindings() {
    $name
      .map(\.isEmpty)
      .removeDuplicates()
      .map(!)
      .assign(to: &$isCreateButtonActive)
  }
}
