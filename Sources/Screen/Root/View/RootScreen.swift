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
    @StateObject var viewModel: RootViewModel
}

extension RootScreen: View {

    var body: some View {
        SwitchRoutes {
            Route("authentication") {
                AuthenticationScreen(
                    viewModel: AuthenticationViewModel(
                        appState: environment.appState,
                        sessionManager: environment.userManager
                    )
                )
            }
            .navigationTransition()
            Route("space") {
                SpaceScreen(
                    spaceViewModel: SpaceViewModel(
                        appState: environment.appState,
                        spaceManager: environment.spaceManager,
                        sessionManager: environment.userManager
                    ),
                    settingsViewModel: ToolbarSettingsViewModel(
                        appState: environment.appState,
                        sessionManager: environment.userManager
                    ),
                    searchViewModel: ToolbarSearchViewModel(
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
                        sessionManager: environment.userManager
                    )
                )
            }
            .navigationTransition()
            Route("space/workspace/:wId", validator: {
                .init(id: $0.parameters["wId"]!)
            }) { (meta: SUWorkspaceMeta) in
                WorkspaceScreen(
                    workspaceViewModel: WorkspaceViewModel(
                        appState: environment.appState,
                        workspaceManager: environment.workspaceManager,
                        sessionManager: environment.userManager,
                        workspaceMeta: meta
                    ),
                    settingsViewModel: ToolbarSettingsViewModel(
                        appState: environment.appState,
                        sessionManager: environment.userManager
                    ),
                    membersViewModel: ToolbarMembersViewModel(
                        appState: environment.appState,
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
                        sessionManager: environment.userManager,
                        workspaceMeta: meta
                    )
                )
            }
            .navigationTransition()
            Route("space/workspace/:wId/document/:dId", validator: {
                .init(
                    id: $0.parameters["dId"]!,
                    workspaceId: $0.parameters["wId"]!
                )
            }) { (meta: SUDocumentMeta) in
                DocumentScreen(
                    documentViewModel: DocumentViewModel(
                        appState: environment.appState,
                        documentManager: environment.documentManager,
                        documentMeta: meta
                    ),
                    settingsViewModel: ToolbarSettingsViewModel(
                        appState: environment.appState,
                        sessionManager: environment.userManager
                    )
                )
            }
            .navigationTransition()
            Route("space/workspace/:wId/members", validator: {
                .init(
                    id: $0.parameters["wId"]!
                )
            }) { (meta: SUWorkspaceMeta) in
                WorkspaceMemberScreen(
                    viewModel: WorkspaceMemberViewModel(
                        appState: environment.appState,
                        memberManager: environment.memberManager,
                        workspaceMeta: meta
                    )
                )
            }
            .navigationTransition()
            Route("space/workspace/:wId/members/invite", validator: {
                .init(
                    id: $0.parameters["wId"]!
                )
            }) { (meta: SUWorkspaceMeta) in
                WorkspaceMemberInviteScreen(
                    viewModel: WorkspaceMemberInviteViewModel(
                        appState: environment.appState,
                        inviteManager: environment.inviteManager,
                        workspaceMeta: meta
                    )
                )
            }
            .navigationTransition()
            Account()
            Route("search") {
                SearchScreen(
                    viewModel: SearchViewModel(
                        appState: environment.appState,
                        searchManager: environment.searchManager,
                        sessionManager: environment.userManager
                    )
                )
            }
        }
        .onAppear(perform: viewModel.handleUserAuthenticationState)
    }

    @ViewBuilder func Account() -> some View {
        Route("account/:uId", validator: {
            .init(id: $0.parameters["uId"]!)
        }) { (meta: SUUserMeta) in
            AccountScreen(
                viewModel: AccountViewModel(
                    appState: environment.appState,
                    userManager: environment.userManager,
                    userMeta: meta
                )
            )
        }
        .navigationTransition()
        Route("account/:uId/invites", validator: {
            .init(id: $0.parameters["uId"]!)
        }) { (meta: SUUserMeta) in
            AccountInviteScreen(
                viewModel: AccountInviteViewModel(
                    appState: environment.appState,
                    accountManager: environment.accountManager,
                    userMeta: meta
                )
            )
        }
        .navigationTransition()
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
