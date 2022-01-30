//
//  SpaceViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 9.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import Combine

let commonWorkspaceUUID = UUID()

let workspaces: [SUWorkspace] = [
//    .init(id: commonWorkspaceUUID, title: "The Amazing Cow-Man"),
//    .init(id: .init(), title: "Cool books"),
//    .init(id: .init(), title: "Extended reality"),
//    .init(id: .init(), title: "Biology project"),
//    .init(id: .init(), title: "Workspace #1")
]

public final class SpaceViewModel: ObservableObject {

    @Published public var title: String = "Space"
    @Published public private(set) var viewItems: [ListTileViewItem] = []

    private var _items = CurrentValueSubject<[SUWorkspace], Never>([])

    private var disposeBag = Set<AnyCancellable>()
    private let environment: Environment
    private var spaceManager: SpaceManager {
        environment.spaceManager
    }
    private var state: AppState {
        environment.state
    }

    public init(environment: Environment = .dev) {
        self.environment = environment
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
        _items.value = spaceManager.getWorkspaces()
    }

    func selectItem(with id: UUID) {
        state.change(route: .read(.workspace(SUWorkspaceMeta(id: id))))
    }

    func createAction() {
        state.change(route: .create)
    }
}

// MARK: - Private interface

private extension SpaceViewModel {

}
