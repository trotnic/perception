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

    private var currentScreen: Screen = .none
    private var screenStack: [Screen] = []

    private let navigator: Navigator

    public init(navigator: Navigator) {
        self.navigator = navigator
    }

    public enum Screen: Equatable {
        public static func == (lhs: AppState.Screen, rhs: AppState.Screen) -> Bool {
            switch (lhs, rhs) {
            case (.back, back),
                (.space, .space),
                (.create, .create),
                (.read, .read),
                (.authentication, .authentication):
                return true
            default:
                return false
            }
        }

        case none
        case back
        case authentication
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
        case .none:
            break
        case .back:
            navigator.goBack()
            screenStack.removeLast()
            currentScreen = screenStack.last!
        case .authentication:
            break
        case .space:
            navigator.navigate("/space")
            screenStack.append(.space)
            currentScreen = .space
        case .create:
            switch currentScreen {
            case .back, .create, .authentication, .none:
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
        SULogger.navigation.log("Changed route")
    }
}
