//
//  SpaceScreen.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 3.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI
import SwiftUIRouter
import SUDesign
import SUFoundation

struct SpaceScreen {

    @StateObject var spaceViewModel: SpaceViewModel
    @StateObject var settingsViewModel: ToolbarSettingsViewModel
    @StateObject var searchViewModel: ToolbarSearchViewModel

    @State private var isToolbarExpanded: Bool = false
}

extension SpaceScreen: View {

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                SUColorStandartPalette.background
                    .ignoresSafeArea()
                VStack {
                    ZStack {
                        Text("Space")
                            .font(.custom("Comfortaa", size: 20).weight(.bold))
                            .foregroundColor(SUColorStandartPalette.text)
                    }
                    .padding(.top, 16.0)
                    .padding(.horizontal, 16.0)
                    ScrollView {
                        VStack(spacing: 40) {
                            listItems
                        }
                        .padding(16)
                    }
                    .frame(maxHeight: .infinity)
                }
                .blur(radius: isToolbarExpanded ? 6.0 : 0.0)
                .overlay {
                    ZStack {
                        SUColorStandartPalette.background
                            .ignoresSafeArea()
                            .opacity(isToolbarExpanded ? 0.2 : 0.0)
                        HStack {
                            Toolbar()
                        }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .padding(.bottom, 10.0)
                    }
                }
            }
        }
        .onAppear(perform: spaceViewModel.load)
    }
}

private extension SpaceScreen {

    func Toolbar() -> some View {
        SUToolbar(
            isExpanded: $isToolbarExpanded,
            defaultTwins: {
                [
                    SUToolbar.Item.Twin(
                        icon: "doc",
                        title: "Create workspace",
                        type: .actionNext,
                        action: spaceViewModel.createAction
                    )
                ]
            },
            leftItems: {
                [
                    // TODO: Consider to move this into viewModel mapping
                    SUToolbar.Item(
                        icon: "gear",
                        twins: [
                            SUToolbar.Item.Twin(
                                icon: "person",
                                title: "Account",
                                type: .actionNext,
                                action: settingsViewModel.accountAction
                            )
                        ]
                    ),
                    SUToolbar.Item(
                        icon: "magnifyingglass",
                        twins: [
                            SUToolbar.Item.Twin(
                                icon: "magnifyingglass",
                                title: "Search",
                                type: .actionNext,
                                action: searchViewModel.searchAction
                            )
                        ]
                    )
                ]
            }
        )
    }

    var listItems: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(minimum: .zero, maximum: .infinity))
            ],
            spacing: 24.0
        ) {
            ForEach(spaceViewModel.items) { item in
                SUListTileWork(
                    emoji: item.emoji,
                    title: item.title,
                    icon: "chevron.right",
                    badges: item.badges.map {
                        SUListTileWork.Badge(
                            title: $0.title,
                            icon: $0.type.icon,
                            color: $0.type.color
                        )
                    },
                    action: item.action
                )
            }
        }
        .foregroundColor(SUColorStandartPalette.text)
    }
}

extension SpaceViewModel.Badge.BadgeType {

    var color: Color {
        switch self {
        case .documents:
            return .red.opacity(0.8)
        case .members:
            return .cyan.opacity(0.8)
        case .dateCreated:
            return .green.opacity(0.8)
        }
    }

    var icon: String {
        switch self {
        case .documents:
            return "doc.on.doc"
        case .members:
            return "person.2"
        case .dateCreated:
            return "clock.arrow.circlepath"
        }
    }
}

// MARK: - Preview

struct SpaceScreen_Previews: PreviewProvider {

    static let spaceViewModel = SpaceViewModel(
        appState: SUAppStateProviderMock(),
        spaceManager: SUManagerSpaceMock(workspaces: {
            [
                SUShallowWorkspace(
                    meta: .empty,
                    title: "Amazing Workspace!",
                    emoji: "❤️",
                    documentsCount: 1,
                    membersCount: 1
                )
            ]
        }),
        sessionManager: SUManagerUserPrimeMock()
    )

    static let settingsViewModel = ToolbarSettingsViewModel(
        appState: SUAppStateProviderMock(),
        sessionManager: SUManagerUserPrimeMock()
    )

    static let searchViewModel = ToolbarSearchViewModel(
        appState: SUAppStateProviderMock()
    )

    static var previews: some View {
        SpaceScreen(
            spaceViewModel: spaceViewModel,
            settingsViewModel: settingsViewModel,
            searchViewModel: searchViewModel
        )
            .previewDevice("iPhone 13 mini")
    }
}
