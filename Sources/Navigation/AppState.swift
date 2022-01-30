//
//  AppState.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 15.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import SwiftUIRouter

public final class AppState: ObservableObject {

    private var currentScreen: Screen = .space
    private var screenStack: [Screen] = [.space]

    private let navigator: Navigator

    public init(navigator: Navigator) {
        self.navigator = navigator
    }

    public enum Screen {
        case back
        case space
        case create
        case read(Content)
    }

    public enum Intention {
        case create
        case read(UUID)
    }

    public enum Content {
        case workspace(SUWorkspaceMeta)
        case shelf(SUShelfMeta)
        case document(SUDocumentMeta)
    }

    public func change(route: Screen) {
        switch route {
        case .back:
            navigator.goBack()
            screenStack.removeLast()
            currentScreen = screenStack.last!
            #warning("should check this later")
        case .space:
            navigator.navigate("/space")
            screenStack.append(.space)
            currentScreen = .space
        case .create:
            switch currentScreen {
            case .back, .create:
                break
            case .space:
                navigator.navigate("/space/create")
            case .read(let content):
                switch content {
                case .workspace(let workspaceMeta):
                    navigator.navigate("/space/workspace/\(workspaceMeta.id)/create")
                case .shelf(let shelfMeta):
                    navigator.navigate("/space/workspace/\(shelfMeta.workspaceId)/shelf/\(shelfMeta.id)/create")
                case .document:
                    break
                }
            }
            currentScreen = .create
            screenStack.append(.create)
        case .read(let content):
            switch content {
            case let .workspace(meta):
                navigator.navigate("/space/workspace/\(meta.id)")
            case let .shelf(meta):
                navigator.navigate("/space/workspace/\(meta.workspaceId)/shelf/\(meta.id)")
            case let .document(meta):
                navigator.navigate("/space/workspace/\(meta.workspaceId)/shelf/\(meta.shelfId)/document/\(meta.id)")
            }
            currentScreen = .read(content)
            screenStack.append(.read(content))
        }
    }
}
