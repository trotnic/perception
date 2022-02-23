//
//  DocumentViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 29.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine
import Foundation
import SUFoundation

public final class DocumentViewModel: ObservableObject {

    @Published public private(set) var title: String = ""
    @Published public var text: String = ""

    private let appState: SUAppStateProvider
    private let documentManager: SUManagerDocument
    private let documentMeta: SUDocumentMeta

    private var disposeBag = Set<AnyCancellable>()

    public init(appState: SUAppStateProvider,
                documentManager: SUManagerDocument,
                documentMeta: SUDocumentMeta) {
        self.appState = appState
        self.documentManager = documentManager
        self.documentMeta = documentMeta
        setupBindings()
    }
}

// MARK: - Public interface

public extension DocumentViewModel {

    func load() {
        Task {
            let workspace = try await documentManager.loadDocument(id: documentMeta.id)
            await MainActor.run {
                title = workspace.title
                text = workspace.text
            }
        }
    }

    func backAction() {
        appState.change(route: .back)
    }

    func deleteAction() {
        Task {
            try await documentManager.deleteDocument(id: documentMeta.id, workspaceId: documentMeta.workspaceId)
            await MainActor.run {
                appState.change(route: .back)
            }
        }
    }
}

// MARK: - Private interface

private extension DocumentViewModel {

    func setupBindings() {
        $text
            .debounce(for: 2.0, scheduler: DispatchQueue.main)
            .sink { [self] value in
                Task {
                    try await documentManager.writeDocument(id: documentMeta.id, text: value)
                }
            }
            .store(in: &disposeBag)
    }
}
