//
//  SearchScreen.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 6.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI
import SUDesign
import SUFoundation

struct SearchScreen {

    @StateObject var viewModel: SearchViewModel
}

extension SearchScreen: View {

    public var body: some View {
        GeometryReader { proxy in
            SUColorStandartPalette
                .background
                .ignoresSafeArea()
            VStack(spacing: 32.0) {
                VStack(spacing: 20.0) {
                    HStack(spacing: 20.0) {
                        SUButtonCircular(
                            icon: "chevron.left",
                            action: viewModel.backAction
                        )
                            .frame(width: 36.0, height: 36.0)
                        SUTextFieldCapsule(
                            text: $viewModel.searchQuery,
                            placeholder: "Search",
                            paddings: UIEdgeInsets(top: 12.0, left: 16.0, bottom: 12.0, right: 16.0)
                        )
                            .frame(height: 40.0)
                    }
                    HStack {
                        SUSegmentPicker(
                            selectedIndex: Binding(
                                get: {
                                    viewModel.searchMode.rawValue
                                },
                                set: { transaction in
                                    viewModel.searchMode = .init(rawValue: transaction)!
                                }
                            ),
                            segments: [
                                "Workspaces",
                                "Documents"
                            ]
                        )
                        Spacer()
//                        SUButtonCircular(icon: "xmark", action: viewModel.backAction)
//                            .frame(width: 36.0, height: 36.0)
                    }
                    .frame(height: 32.0)
                }
                ScrollView {
                    VStack(spacing: 20.0) {
                        ForEach(viewModel.items) { item in
                            SUListTileWork(
                                emoji: item.emoji,
                                title: item.title,
                                icon: "chevron.right",
                                action: {
                                    viewModel.readAction(id: item.id)
                                }
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, 16.0)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
}

struct SearchScreen_Previews: PreviewProvider {

    static let viewModel = SearchViewModel(
        appState: SUAppStateProviderMock(),
        searchManager: SUManagerSearchMock(
            workspaces: {
                [
                    SUShallowWorkspace(
                        meta: .init(id: "#1"),
                        title: "One workspace", emoji: "❤️"
                    ),
                    SUShallowWorkspace(
                        meta: .init(id: "#2"),
                        title: "Two workspace", emoji: "❤️"
                    ),
                    SUShallowWorkspace(
                        meta: .init(id: "#3"),
                        title: "Three workspace", emoji: "❤️"
                    ),
                    SUShallowWorkspace(
                        meta: .init(id: "#4"),
                        title: "Four workspace", emoji: "❤️"
                    )
                ]
            }
        ),
        sessionManager: SUManagerUserPrimeMock()
    )

    static var previews: some View {
        SearchScreen(viewModel: viewModel)
            .onAppear {
                viewModel.searchQuery = "Some"
            }
    }
}
