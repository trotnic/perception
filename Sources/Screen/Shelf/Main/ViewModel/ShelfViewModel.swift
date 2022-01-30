//
//  ShelfViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 21.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import Combine

let documents: [SUDocument] = [
//    .init(id: .init(), shelfId: commonShelfUUID, workspaceId: commonWorkspaceUUID, title: "Document #\(#line)"),
//    .init(id: .init(), shelfId: commonShelfUUID, workspaceId: commonWorkspaceUUID, title: "Document #\(#line)"),
//    .init(id: .init(), shelfId: commonShelfUUID, workspaceId: commonWorkspaceUUID, title: "Document #\(#line)"),
//    .init(id: .init(), shelfId: commonShelfUUID, workspaceId: commonWorkspaceUUID, title: "Document #\(#line)"),
]

public final class ShelfViewModel: ObservableObject {

    @Published public private(set) var navigationTitle: String = "Shelf"
    @Published public private(set) var shelfTitle: String = ""
    @Published public private(set) var documentsCount: Int = 42
    @Published public private(set) var viewItems: [ListTileViewItem] = []
    private var shelfItem: SUShelf!

    private let environment: Environment
    private var spaceManager: SpaceManager {
        environment.spaceManager
    }

    private var state: AppState {
        environment.state
    }

    public init(meta: SUShelfMeta, environment: Environment = .dev) {
        self.environment = environment
    }
}

// MARK: - Public interface

public extension ShelfViewModel {


    func loadShelfIfNeeded() {
//        guard let shelfId = state.currentSelection else {
//            return
//        }
//        shelfItem = shelfs.first(where: { $0.id == shelfId })
//        shelfTitle = shelfItem.title
//        viewItems = documents.filter { $0.shelfId == shelfId }.map { item in
//            let viewItem = ListTileViewItem(
//                id: item.id,
//                iconText: "",
//                title: item.title
//            )
//            return viewItem
//        }
    }

    func selectItem(with id: UUID) {
//        state.change(route: .shelf(.read(id)))
    }

    func backAction() {
        state.change(route: .back)
    }
}

// MARK: - Private interface

private extension ShelfViewModel {
    
}
