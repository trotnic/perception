//
//  AccountInviteScreen.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 13.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SUDesign
import SwiftUI
import SUFoundation

struct AccountInviteScreen {

    @StateObject var viewModel: AccountInviteViewModel
}

extension AccountInviteScreen: View {

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                SUColorStandartPalette.background
                    .ignoresSafeArea()
                VStack {
                    ZStack {
                        VStack {
                            SUButtonCircular(
                                icon: "chevron.left",
                                action: viewModel.backAction
                            )
                        }
                        .padding(.leading, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Invites")
                            .font(.custom("Comfortaa", size: 20).bold())
                            .foregroundColor(SUColorStandartPalette.text)
                    }
                    .padding(.top, 16.0)
                    ScrollView {
                        VStack(spacing: 40) {
                            WorkspaceList()
                        }
                        .padding(16)
                    }
                    .frame(maxHeight: .infinity)
                }
            }
        }
        .onAppear(perform: viewModel.loadAction)
    }
}

private extension AccountInviteScreen {

    func WorkspaceList() -> some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(minimum: .zero, maximum: .infinity))
            ],
            spacing: 24.0
        ) {
            ForEach(viewModel.items) { item in
                SUListTileInvite(
                    content: .init(
                        title: item.title,
                        emoji: item.emoji,
                        badges: item.badges.map { badge in
                            .init(
                                title: badge.title,
                                icon: badge.type.icon,
                                color: badge.type.color
                            )
                        }
                    ),
                    confirmAction: item.confirmAction,
                    rejectAction: item.rejectAction
                )
            }
        }
        .foregroundColor(SUColorStandartPalette.text)
    }
}

extension AccountInviteViewModel.Badge.BadgeType {

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

struct AccountInviteScreen_Previews: PreviewProvider {

    static let viewModel = AccountInviteViewModel(
        appState: SUAppStateProviderMock(),
        accountManager: SUManagerAccountMock(
            workspaces: {
                [
                    SUShallowWorkspace(
                        meta: SUWorkspaceMeta(
                            id: "#1"
                        ),
                        title: "Ma Title",
                        emoji: "🔥",
                        documentsCount: 2,
                        membersCount: 3
                    )
                ]
            }
        ),
        userMeta: .empty
    )

    static var previews: some View {
        AccountInviteScreen(
            viewModel: viewModel
        )
    }
}
