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

    @Published var itemName: String = ""

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
    }
}

public extension WorkspaceCreateViewModel {

    func backAction() {
        appState.change(route: .back)
    }

    func createAction() {
        Task {
            let documentId = try await workspaceManager.createDocument(title: itemName,
                                                                       workspaceId: workspaceMeta.id,
                                                                       userId: sessionManager.userId)
            appState.change(route: .read(.document(SUDocumentMeta(id: documentId, workspaceId: workspaceMeta.id))))
        }
    }
}
