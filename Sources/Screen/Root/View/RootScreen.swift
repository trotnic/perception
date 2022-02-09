//
//  RootScreen.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 15.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI
import SwiftUIRouter

struct RootScreen: View {

    @StateObject var viewModel: RootViewModel

    var body: some View {
        SwitchRoutes {
            Route("authentication") {
                AuthenticationScreen(viewModel: AuthenticationViewModel())
            }
            .navigationTransition()
            Route("space") {
                SpaceScreen(spaceViewModel: SpaceViewModel(), settingsViewModel: ToolbarSettingsViewModel())
            }
            .navigationTransition()
            Route("space/create") {
                SpaceCreateScreen(viewModel: SpaceCreateViewModel())
            }
            .navigationTransition()
            Route("space/workspace/:wId", validator: {
                .init(id: $0.parameters["wId"]!)
            }) { (meta: SUWorkspaceMeta) in
                WorkspaceScreen(viewModel: WorkspaceViewModel(meta: meta))
            }
            .navigationTransition()
            Route("space/workspace/:wId/create", validator: {
                .init(id: $0.parameters["wId"]!)
            }) { (meta: SUWorkspaceMeta) in
                WorkspaceCreateScreen(viewModel: WorkspaceCreateViewModel(meta: meta))
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
                AccountScreen(viewModel: AccountViewModel())
            }
            .navigationTransition()
            Route {
                Navigate(to: "/authentication")
            }
        }
    }

    @inline(__always)
    private func parse(route: RouteInformation, id: String) -> UUID {
        UUID(uuidString: route.parameters[id]!)!
    }
}

struct RootScreen_Previews: PreviewProvider {

    static let viewModel = RootViewModel()

    static var previews: some View {
        RootScreen(viewModel: viewModel)
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
