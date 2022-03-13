//
//  SUAppState.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 15.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import SwiftUIRouter
import SUFoundation

/**
 
            +----------back------------+
            |                          |
            |                          |
           \ /                         |
          space ----> create ----> workspace

            +----------back------------+
            |                          |
            |                          |
           \ /                         |
        workspace ----> create ----> document
 
 */

public final class SUAppState: SUAppStateProvider {

    private var currentScreen: SUAppScreen = .none
    private var screenStack: [SUAppScreen] = []

    private let navigator: Navigator

    public init(navigator: Navigator) {
        self.navigator = navigator
    }

    public func change(route: SUAppScreen) {
        switch route {
        case .none:
            break
        case .back:
            navigator.goBack()
            screenStack.removeLast()
            currentScreen = screenStack.last!
        case .authentication:
            navigator.navigate("/authentication")
            screenStack.removeAll()
            currentScreen = .authentication
        case .account(let userMeta):
            navigator.navigate("/account/\(userMeta.id)")
            screenStack.append(.account(userMeta))
            currentScreen = .account(userMeta)
        case .space:
            navigator.navigate("/space")
            screenStack.append(.space)
            currentScreen = .space
        case .create:
            switch currentScreen {
            case .back, .create, .authentication, .account, .none, .search, .members, .invite:
                fatalError("This should never happen")
            case .space:
                navigator.navigate("/space/create")
            case .read(let content):
                switch content {
                case .workspace(let workspaceMeta):
                    navigator.navigate("/space/workspace/\(workspaceMeta.id)/create")
                case .document:
                    break
                }
            }
            currentScreen = .create
            screenStack.append(.create)
        case .read(let content):
            switch currentScreen {
            case .none, .account, .authentication, .back, .members, .invite:
                fatalError("This should never happen")
            case .read, .space, .search:
                switch content {
                case let .workspace(meta):
                    navigator.navigate("/space/workspace/\(meta.id)")
                case let .document(meta):
                    navigator.navigate("/space/workspace/\(meta.workspaceId)/document/\(meta.id)")
                }
            case .create:
                switch content {
                case let .workspace(meta):
                    navigator.navigate("/space/workspace/\(meta.id)", replace: true)
                case let .document(meta):
                    navigator.navigate("/space/workspace/\(meta.workspaceId)/document/\(meta.id)", replace: true)
                }
                screenStack.removeLast()
            }
            currentScreen = .read(content)
            screenStack.append(.read(content))
        case .search:
            navigator.navigate("/search")
            currentScreen = .search
            screenStack.append(.search)
        case .members(let meta):
            navigator.navigate("/space/workspace/\(meta.id)/members")
            currentScreen = .members(meta)
            screenStack.append(.members(meta))
        case .invite(let meta):
            navigator.navigate("/space/workspace/\(meta.id)/members/invite")
            currentScreen = .invite(meta)
            screenStack.append(.invite(meta))
        }
        SULogger.navigation.log("Changed route")
    }
}
