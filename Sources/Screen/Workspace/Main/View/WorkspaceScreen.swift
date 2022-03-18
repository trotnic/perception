//
//  WorkspaceScreen.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 13.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI
import SwiftUIRouter
import SUDesign
import SUFoundation

struct WorkspaceScreen {

    @StateObject var workspaceViewModel: WorkspaceViewModel
    @StateObject var settingsViewModel: ToolbarSettingsViewModel
    @StateObject var membersViewModel: ToolbarMembersViewModel

    @FocusState private var emojiButtonFocus: Bool
    @State private var isToolbarExpanded: Bool = false
}

extension WorkspaceScreen: View {

    var body: some View {
        GeometryReader { proxy in
            SUColorStandartPalette.background
                .edgesIgnoringSafeArea(.all)
            VStack {
                ZStack {
                    VStack {
                        SUButtonCircular(
                            icon: "chevron.left",
                            action: workspaceViewModel.backAction
                        )
                            .frame(width: 36.0, height: 36.0)
                    }
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    VStack {
                        Text("Workspace")
                            .font(.custom("Comfortaa", size: 20).weight(.bold))
                            .foregroundColor(SUColorStandartPalette.text)
                    }
                }
                .padding(.top, 16)
                ScrollView {
                    VStack(spacing: 40) {
                        TopTile()
                        ListItems()
                    }
                    .padding(16)
                }
                .onTapGesture {
                    emojiButtonFocus = false
                }
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
}

private extension WorkspaceScreen {

    func TopTile() -> some View {
        ZStack {
            SUColorStandartPalette.tile
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    SUButtonEmoji(text: $workspaceViewModel.emoji, commit: {})
                        .focused($emojiButtonFocus)
                    TextField("", text: $workspaceViewModel.title)
                        .font(.custom("Comfortaa", size: 18.0).weight(.bold))
                }
                RoundedRectangle(cornerRadius: 1)
                    .fill(.white.opacity(0.2))
                    .frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                HStack(spacing: 12) {
                    Text("\(workspaceViewModel.membersCount) members")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke()
                                .fill(SUColorStandartPalette.redOutline)
                        }
                    Text("\(workspaceViewModel.documentsCount) documents")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke()
                                .fill(SUColorStandartPalette.redOutline)
                        }
                }
                .font(.custom("Comfortaa", size: 14).weight(.bold))
            }
            .foregroundColor(SUColorStandartPalette.text)
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .mask {
            RoundedRectangle(cornerRadius: 20)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke()
                .fill(.white.opacity(0.2))
        }
        .onAppear(perform: workspaceViewModel.loadAction)
        .onDisappear {
            emojiButtonFocus = false
        }
    }

    func Toolbar() -> some View {
        SUToolbar(
            isExpanded: $isToolbarExpanded,
            defaultTwins: {
                workspaceViewModel
                    .actions
                    .map {
                        SUToolbar.Item.Twin(
                            icon: $0.icon,
                            title: $0.title,
                            type: $0.rowType,
                            action: $0.action
                        )
                    }
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
            },
            rightItems: {
                [
                    SUToolbar.Item(
                        icon: "person.2",
                        twins: [
                            SUToolbar.Item.Twin(
                                icon: "person.2",
                                title: "Members",
                                type: .actionNext,
                                action: membersViewModel.membersAction
                            )
                        ]
                    )
                ]
            }
        )
    }

    func ListItems() -> some View {
        LazyVGrid(columns: [
            GridItem(.flexible(minimum: .zero, maximum: .infinity))
        ], spacing: 24) {
            ForEach(workspaceViewModel.viewItems) { item in
                SUListTileWork(
                    emoji: item.emoji,
                    title: item.title,
                    icon: "chevron.right",
                    badges: [],
                    action: item.action
                )
            }
        }
        .foregroundColor(SUColorStandartPalette.text)
    }
}

extension WorkspaceViewModel.ActionItem {

    var icon: String {
        switch self.type {
        case .create:
            return "doc"
        case .delete:
            return "trash"
        }
    }

    var title: String {
        switch self.type {
        case .create:
            return "Create document"
        case .delete:
            return "Delete workspace"
        }
    }

    var rowType: SUToolbar.Row  {
        switch self.type {
        case .create:
            return .actionNext
        case .delete:
            return .action
        }
    }
}

extension View {
    func debug() -> some View {
        dump(self)
        return self
    }
}

// MARK: - Preview

struct WorkspaceScreen_Previews: PreviewProvider {

    static let workspaceViewModel = WorkspaceViewModel(
        appState: SUAppStateProviderMock(),
        workspaceManager: SUManagerWorkspaceMock(meta: {
            .empty
        }, title: {
            "Title"
        }, documents: {
            [
                SUShallowDocument(
                    meta: SUDocumentMeta(
                        id: "#1",
                        workspaceId: "w1"
                    ),
                    title: "Document #1",
                    emoji: "❤️"
                ),
            ]
        }, members: {
            [
                SUShallowWorkspaceMember(
                    id: .empty,
                    permission: 0
                )
            ]
        }),
        sessionManager: SUManagerUserPrimeMock(),
        workspaceMeta: .empty
    )

    static let settingsViewModel = ToolbarSettingsViewModel(
        appState: SUAppStateProviderMock(),
        sessionManager: SUManagerUserPrimeMock()
    )

    static let membersViewModel = ToolbarMembersViewModel(
        appState: SUAppStateProviderMock(),
        workspaceMeta: .empty
    )

    static var previews: some View {
        ZStack {
            WorkspaceScreen(
                workspaceViewModel: workspaceViewModel,
                settingsViewModel: settingsViewModel,
                membersViewModel: membersViewModel
            )
                .previewDevice("iPhone 13 mini")
        }
    }
}
