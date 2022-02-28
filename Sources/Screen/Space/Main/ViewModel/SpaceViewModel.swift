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

    private var _items = CurrentValueSubject<[SUShallowWorkspace], Never>([])

    private var disposeBag = Set<AnyCancellable>()

    private let appState: SUAppStateProvider
    private let spaceManager: SUManagerSpace
    private let userManager: SUManagerUser

    public init(
        appState: SUAppStateProvider,
        spaceManager: SUManagerSpace,
        userManager: SUManagerUser
    ) {
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

    @MainActor
    func load() async {
        do {
            _items.value = try await spaceManager.loadWorkspaces(for: userManager.userId)
        } catch {
            print(error)
        }
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
