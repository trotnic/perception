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

    var body: some View {
        SwitchRoutes {
            Route("space") {
                SpaceScreen(viewModel: SpaceViewModel())
            }
            .navigationTransition()
            Route("space/create") {
                SpaceCreateScreen()
            }
            .navigationTransition()
            Route("space/workspace/:wId", validator: {
                .init(id: parse(route: $0, id: "wId"))
            }) { (meta: SUWorkspaceMeta) in
                WorkspaceScreen(viewModel: WorkspaceViewModel(meta: meta))
            }
            .navigationTransition()
            Route("space/workspace/:wId/create", validator: {
                .init(id: parse(route: $0, id: "wId"))
            }) { (meta: SUWorkspaceMeta) in
                Text("Shelf create")
            }
            .navigationTransition()
            Route("space/workspace/:wId/shelf/:sId", validator: {
                .init(id: parse(route: $0, id: "wId"),
                      workspaceId: parse(route: $0, id: "sId"))
            }) { (meta: SUShelfMeta) in
                ShelfScreen(viewModel: ShelfViewModel(meta: meta))
            }
            .navigationTransition()
            Route("space/workspace/:wId/shelf/:sId/create", validator: {
                .init(id: parse(route: $0, id: "wId"),
                      workspaceId: parse(route: $0, id: "sId"))
            }) { (meta: SUShelfMeta) in
                Text("Document create")
            }
            .navigationTransition()
            Route("space/workspace/:wId/shelf/:sId/document/:dId", validator: {
                .init(id: parse(route: $0, id: "wId"),
                      shelfId: parse(route: $0, id: "sId"),
                      workspaceId: parse(route: $0, id: "dId"))
            }) { (meta: SUDocumentMeta) in
                DocumentScreen(viewModel: DocumentViewModel(meta: meta))
            }
            .navigationTransition()
            Route {
                Navigate(to: "/space")
            }
        }
    }

    @inline(__always)
    private func parse(route: RouteInformation, id: String) -> UUID {
        UUID(uuidString: route.parameters[id]!)!
    }
}

struct RootScreen_Previews: PreviewProvider {
    static var previews: some View {
        RootScreen()
    }
}

struct NavigationTransition: ViewModifier {
    @EnvironmentObject private var navigator: Navigator
    
    func body(content: Content) -> some View {
        content
            .animation(.easeInOut, value: navigator.path)
            .transition(
                navigator.lastAction?.direction == .deeper
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
