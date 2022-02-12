//
//  RootScreen.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 15.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI
import SwiftUIRouter
import SUFoundation

struct RootScreen {

    let environment: SUEnvironment
}

extension RootScreen: View {

    var body: some View {
        SwitchRoutes {
            Route("authentication") {
                AuthenticationScreen(
                    viewModel: AuthenticationViewModel(
                        appState: environment.appState,
                        userManager: environment.userManager
                    )
                )
            }
            .navigationTransition()
            Route("space") {
                SpaceScreen(
                    spaceViewModel: SpaceViewModel(
                        appState: environment.appState,
                        spaceManager: environment.spaceManager,
                        userManager: environment.userManager
                    ),
                    settingsViewModel: ToolbarSettingsViewModel(
                        appState: environment.appState
                    )
                )
            }
            .navigationTransition()
            Route("space/create") {
                SpaceCreateScreen(
                    viewModel: SpaceCreateViewModel(
                        appState: environment.appState,
                        spaceManager: environment.spaceManager,
                        userManager: environment.userManager
                    )
                )
            }
            .navigationTransition()
            Route("space/workspace/:wId", validator: {
                .init(id: $0.parameters["wId"]!)
            }) { (meta: SUWorkspaceMeta) in
                WorkspaceScreen(
                    viewModel: WorkspaceViewModel(
                        appState: environment.appState,
                        workspaceManager: environment.workspaceManager,
                        workspaceMeta: meta
                    )
                )
            }
            .navigationTransition()
            Route("space/workspace/:wId/create", validator: {
                .init(id: $0.parameters["wId"]!)
            }) { (meta: SUWorkspaceMeta) in
                WorkspaceCreateScreen(
                    viewModel: WorkspaceCreateViewModel(
                        appState: environment.appState,
                        workspaceManager: environment.workspaceManager,
                        userManager: environment.userManager,
                        workspaceMeta: meta
                    )
                )
            }
            .navigationTransition()
            Route("space/workspace/:wId/document/:dId", validator: {
                .init(id: $0.parameters["dId"]!,
                      workspaceId: $0.parameters["wId"]!)
            }) { (meta: SUDocumentMeta) in
                VStack {
                    Text(meta.id)
                    Text(meta.workspaceId)
                }
//                DocumentScreen(viewModel: DocumentViewModel(meta: meta))
            }
            .navigationTransition()
            Route("account") {
                AccountScreen(
                    viewModel: AccountViewModel(
                        appState: environment.appState,
                        userManager: environment.userManager
                    )
                )
            }
            .navigationTransition()
            Route {
                Navigate(to: "/authentication")
            }
        }
    }
}

struct NavigationTransition: ViewModifier {
    @EnvironmentObject private var navigator: Navigator
    
    func body(content: Content) -> some View {
        content
            .animation(.easeInOut, value: navigator.path)
            .transition(
                navigator.lastAction?.direction == .deeper || navigator.lastAction?.direction == .sideways
                    ? AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
                    : AnyTransition.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))
            )
    }
}

extension View {
    func navigationTransition() -> some View {
        modifier(NavigationTransition())
    }
}
