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
    @State private var navbarFrame: CGRect = .zero
    @State private var tileFrame: CGRect = .zero
    @State private var toolbarFrame: CGRect = .zero
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
                    Group {
                        if spaceViewModel.isSpaceEmpty {
                            VStack(alignment: .center, spacing: 32.0) {
                                Text("You didn’t create any workspace yet 😿")
                                    .font(.custom("Cofmortaa", size: 22.0).bold())
                                    .frame(maxWidth: proxy.size.width - 60.0)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(SUColorStandartPalette.secondary1)
                                SUButtonCapsule(
                                    isActive: .constant(true),
                                    title: "Create new workspace",
                                    size: CGSize(width: proxy.size.width - 32.0, height: 56.0),
                                    action: spaceViewModel.createAction
                                )
                            }
                        } else {
                            GeometryReader { scrollProxy in
                                ScrollView {
                                    VStack(spacing: 40) {
                                        ListItems()
                                    }
                                    .padding(16)
                                    Color.clear
                                        .padding(.bottom, toolbarFrame.height)
                                }
                                .overlay {
                                    VStack {
                                        if tileFrame.origin.y < navbarFrame.origin.y {
                                            VStack {
                                                Rectangle()
                                                    .fill(SUColorStandartPalette.secondary3)
                                                    .frame(height: 1.0)
                                                    .frame(maxWidth: .infinity)
                                                Spacer()
                                            }
                                        }
                                    }
                                }
                                .overlay {
                                    Color.clear
                                    .preference(key: SUFrameKey.self, value: scrollProxy.frame(in: .global))
                                    .onPreferenceChange(SUFrameKey.self) { navbarFrame = $0 }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                .blur(radius: isToolbarExpanded ? 2.0 : 0.0)
                .overlay {
                    ZStack {
                        SUColorStandartPalette.background
                            .ignoresSafeArea()
                            .opacity(isToolbarExpanded ? 0.2 : 0.0)
                        HStack {
                            Toolbar()
                                .background {
                                    GeometryReader { proxy in
                                        SUColorStandartPalette.background
                                            .frame(height: proxy.size.height * 2.0)
                                            .offset(y: -12.0)
                                            .blur(radius: 6.0)
                                            .preference(key: SUFrameKey.self, value: proxy.frame(in: .global))
                                            .onPreferenceChange(SUFrameKey.self) { toolbarFrame = $0 }
                                    }
                                }
                        }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .padding(.bottom, 10.0)
                    }
                }
            }
        }
        .onAppear(perform: spaceViewModel.loadAction)
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

    func ListItems() -> some View {
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
                .background {
                    if item.index == 0 {
                        GeometryReader { proxy in
                            Color.clear
                                .preference(key: SUFrameKey.self, value: proxy.frame(in: .global))
                                .onPreferenceChange(SUFrameKey.self) { tileFrame = $0 }
                        }
                    }
                }
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
                    meta: .init(id: UUID().uuidString),
                    title: "Amazing Workspace!",
                    emoji: "❤️",
                    documentsCount: 1,
                    membersCount: 1
                ),
                SUShallowWorkspace(
                    meta: .init(id: UUID().uuidString),
                    title: "Amazing Workspace!",
                    emoji: "❤️",
                    documentsCount: 1,
                    membersCount: 1
                ),
                SUShallowWorkspace(
                    meta: .init(id: UUID().uuidString),
                    title: "Amazing Workspace!",
                    emoji: "❤️",
                    documentsCount: 1,
                    membersCount: 1
                ),
                SUShallowWorkspace(
                    meta: .init(id: UUID().uuidString),
                    title: "Amazing Workspace!",
                    emoji: "❤️",
                    documentsCount: 1,
                    membersCount: 1
                ),
                SUShallowWorkspace(
                    meta: .init(id: UUID().uuidString),
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
