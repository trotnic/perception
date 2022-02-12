//
//  SpaceViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 9.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import Combine
import SUFoundation

public final class SpaceViewModel: ObservableObject {

    @Published public var title: String = "Space"
    @Published public private(set) var viewItems: [ListTileViewItem] = []

    private var _items = CurrentValueSubject<[SUWorkspace], Never>([])

    private var disposeBag = Set<AnyCancellable>()

    private let appState: AppState
    private let spaceManager: SpaceManager
    private let userManager: UserManager

    public init(appState: AppState,
                spaceManager: SpaceManager,
                userManager: UserManager) {
        self.appState = appState
        self.spaceManager = spaceManager
        self.userManager = userManager
        _items
            .map { items in
                items.map { item in
                    let viewItem = ListTileViewItem(
                        id: item.meta.id,
                        iconText: "",
                        title: item.title
                    )
                    return viewItem
                }
            }
            .sink {
                self.viewItems = $0
            }
            .store(in: &disposeBag)
    }
}

// MARK: - Public interface

public extension SpaceViewModel {

    func load() {
        Task {
            try await _load()
        }
    }

    @MainActor
    func _load() async throws {
        _items.value = try await spaceManager.loadWorkspaces(for: userManager.userId)
    }

    func selectItem(with id: String) {
        appState.change(route: .read(.workspace(SUWorkspaceMeta(id: id))))
    }

    func createAction() {
        appState.change(route: .create)
    }
}

// MARK: - Private interface

private extension SpaceViewModel {

}
