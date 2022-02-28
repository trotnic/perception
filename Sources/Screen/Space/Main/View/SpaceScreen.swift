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
}

extension SpaceScreen: View {

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                SUColorStandartPalette.background
                    .ignoresSafeArea()
                VStack {
                    ZStack {
                        Text(spaceViewModel.title)
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
                .overlay {
                    HStack {
                        toolbar
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom, 10.0)
                }
            }
        }
        .task {
            await spaceViewModel.load()
        }
    }
}

private extension SpaceScreen {

    var toolbar: some View {
        SUToolbar(
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
            ForEach(spaceViewModel.viewItems) { item in
                SUListTile(
                    emoji: item.iconText,
                    title: item.title,
                    icon: "chevron.right"
                ) {
                    spaceViewModel.selectItem(with: item.id)
                }
            }
        }
        .foregroundColor(SUColorStandartPalette.text)
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
                    title: "Amazing Workspace!"
                )
            ]
        }),
        userManager: SUManagerUserMock()
    )

    static let settingsViewModel = ToolbarSettingsViewModel(
        appState: SUAppStateProviderMock()
    )

    static var previews: some View {
        SpaceScreen(
            spaceViewModel: spaceViewModel,
            settingsViewModel: settingsViewModel
        )
//            .previewDevice("iPod touch (7th generation)")
            .previewDevice("iPhone 13 mini")
    }
}
