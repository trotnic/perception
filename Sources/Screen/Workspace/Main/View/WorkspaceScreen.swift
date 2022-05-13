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

  @State private var navbarFrame: CGRect = .zero
  @State private var tileFrame: CGRect = .zero
  @State private var toolbarFrame: CGRect = .zero
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
          }
          .padding(.leading, 16)
          .frame(maxWidth: .infinity, alignment: .leading)
          VStack(
            spacing: 2.0
          ) {
            Text("Workspace")
              .font(.custom("Comfortaa", size: 16.0).weight(.bold))
              .foregroundColor(SUColorStandartPalette.text)
            if tileFrame.origin.y < navbarFrame.origin.y {
              Text(workspaceViewModel.title)
                .font(.custom("Comfortaa", size: 12.0).weight(.bold))
                .foregroundColor(SUColorStandartPalette.text)
            }
          }
          .animation(.easeInOut(duration: 0.12), value: tileFrame.origin.y < navbarFrame.origin.y)
        }
        .padding(.top, 16.0)
        GeometryReader { scrollProxy in
          ScrollView {
            VStack(
              spacing: 40.0
            ) {
              TopTile()
                .background {
                  GeometryReader { proxy in
                    Color.clear
                      .preference(key: SUFrameKey.self, value: proxy.frame(in: .global))
                      .onPreferenceChange(SUFrameKey.self) { tileFrame = $0 }
                  }
                }
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
        .onTapGesture {
          emojiButtonFocus = false
        }
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
            .textFieldStyle(PlainTextFieldStyle())
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
          badges: item.badges.map {
            .init(
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

extension WorkspaceViewModel.Badge.BadgeType {

  var icon: String {
    switch self {
      case .dateCreated:
        return "calendar.badge.plus"
    }
  }

  var color: Color {
    switch self {
      case .dateCreated:
        return .green.opacity(0.8)
    }
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
          emoji: "❤️",
          dateCreated: Date.now
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
