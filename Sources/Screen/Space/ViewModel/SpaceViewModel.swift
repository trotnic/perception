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
    .init(id: commonWorkspaceUUID, title: "The Amazing Cow-Man", iconText: "🔥", membersCount: (0...52).randomElement()!, dateCreated: Date()),
    .init(id: .init(), title: "Cool books", iconText: "📚", membersCount: (0...52).randomElement()!, dateCreated: Date()),
    .init(id: .init(), title: "Extended reality", iconText: "🌎", membersCount: (0...52).randomElement()!, dateCreated: Date()),
    .init(id: .init(), title: "Biology project", iconText: "👩‍🔬", membersCount: (0...52).randomElement()!, dateCreated: Date()),
    .init(id: .init(), title: "Workspace #1", iconText: "😀", membersCount: (0...52).randomElement()!, dateCreated: Date())
]

public final class SpaceViewModel: ObservableObject {

    @Published public var title: String = "Space"
    @Published public var viewItems: [ListTileViewItem] = []

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
                        id: item.id,
                        iconText: item.iconText,
                        title: item.title
//                        membersTitle: "\(item.membersCount) members",
//                        lastEditTitle: item.dateCreated.debugDescription
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
        self._items.value = workspaces
//        let result = LocalRepository.shared.readWorkspaces()
//        switch result {
//        case .success(let items):
//            self._items.value = items
//        case .failure(let error):
//            print(error)
//        }
    }

    func selectItem(with id: UUID) {
        state.change(route: .workspace(id))
    }
}

// MARK: - Private interface

private extension SpaceViewModel {

    private func persist(title: String) {
        let workspaceId = spaceManager.createWorkspace(name: title)
        state.change(route: .workspace(workspaceId))
    }

    private func select(item: SUWorkspace) {
        state.change(route: .workspace(item.id))
    }
}
