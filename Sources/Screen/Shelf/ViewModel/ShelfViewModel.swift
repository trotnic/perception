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
    .init(id: .init(), shelfId: commonShelfUUID, title: "Document #\(#line)", lastEditTime: .now),
    .init(id: .init(), shelfId: commonShelfUUID, title: "Document #\(#line)", lastEditTime: .now),
    .init(id: .init(), shelfId: commonShelfUUID, title: "Document #\(#line)", lastEditTime: .now),
    .init(id: .init(), shelfId: commonShelfUUID, title: "Document #\(#line)", lastEditTime: .now),
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

    public init(environment: Environment = .dev) {
        self.environment = environment
    }
}

// MARK: - Public interface

public extension ShelfViewModel {


    func loadShelfIfNeeded() {
        guard case .shelf(let shelfId) = state.currentSelection else {
            return
        }
        shelfItem = shelfs.first(where: { $0.id == shelfId })
        shelfTitle = shelfItem.title
        viewItems = documents.filter { $0.shelfId == shelfId }.map { item in
            let viewItem = ListTileViewItem(
                id: item.id,
                iconText: "",
                title: item.title
            )
            return viewItem
        }
    }

    func selectItem(with id: UUID) {
        
    }
}

// MARK: - Private interface

private extension ShelfViewModel {
    
}
