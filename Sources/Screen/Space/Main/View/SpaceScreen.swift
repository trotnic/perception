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
                        Group {
                            SUButtonCircular(icon: "plus") {
                                spaceViewModel.createAction()
                            }
                            .frame(width: 36.0, height: 36.0)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
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
                    SUToolbar(isExpanded: $isToolbarExpanded,
                              defaultTwins: [
                                SUToolbar.Item.Twin(icon: "doc", title: "Create document", type: .actionNext) {}
                              ],
                              leftItems: [
                                .init(icon: "gear", twins: [
                                    .init(icon: "person", title: "Account", type: .actionNext) {
                                        settingsViewModel.accountAction()
                                    }
                                ])
                    ])
                }
            }
        }
        .task {
            await spaceViewModel.load()
        }
    }

    @ViewBuilder private var listItems: some View {
        LazyVGrid(columns: [
            .init(.flexible(minimum: .zero, maximum: .infinity))
        ], spacing: 24) {
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
            .previewDevice("iPhone 13 mini")
    }
}
