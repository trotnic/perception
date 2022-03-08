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

    @Published public var title: String = .empty
    @Published public var description: String = .empty
    @Published public var emoji: String = .empty
    @Published public var text: String = .empty

    private let appState: SUAppStateProvider
    private let documentManager: SUManagerDocument
    private let documentMeta: SUDocumentMeta

    private var disposeBag = Set<AnyCancellable>()

    public init(
        appState: SUAppStateProvider,
        documentManager: SUManagerDocument,
        documentMeta: SUDocumentMeta
    ) {
        self.appState = appState
        self.documentManager = documentManager
        self.documentMeta = documentMeta

        setupBindings()
    }
}

// MARK: - Public interface

public extension DocumentViewModel {

    func load() {
        documentManager.observe(documentId: documentMeta.id)
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
        documentManager
            .document
//            .drop(while: { $0 == SUDocument.empty })
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [self] document in
                title = document.title
                emoji = document.emoji
                text = document.text
            })
            .store(in: &disposeBag)

        $title
            .debounce(for: 1.5, scheduler: DispatchQueue.main)
            .sink { [self] value in
                Task {
                    try await documentManager.updateDocument(id: documentMeta.id, title: value)
                }
            }
            .store(in: &disposeBag)

        $emoji
            .debounce(for: 1.5, scheduler: DispatchQueue.main)
            .sink { [self] value in
                Task {
                    try await documentManager.updateDocument(id: documentMeta.id, emoji: value)
                }
            }
            .store(in: &disposeBag)

        $text
            .debounce(for: 2.0, scheduler: DispatchQueue.main)
            .sink { [self] value in
                Task {
                    try await documentManager.updateDocument(id: documentMeta.id, text: value)
                }
            }
            .store(in: &disposeBag)
    }
}
