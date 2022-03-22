//
//  WorkspaceMemberScreen.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 7.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SUDesign
import SUFoundation
import SwiftUI

struct WorkspaceMemberScreen {

    @StateObject var viewModel: WorkspaceMemberViewModel

    @State private var navbarFrame: CGRect = .zero
    @State private var tileFrame: CGRect = .zero
}

extension WorkspaceMemberScreen: View {

    var body: some View {
        GeometryReader { proxy in
            SUColorStandartPalette.background
                .edgesIgnoringSafeArea(.all)
            VStack {
                ZStack {
                    VStack {
                        SUButtonCircular(
                            icon: "chevron.left",
                            action: viewModel.backAction
                        )
                            .frame(width: 36.0, height: 36.0)
                    }
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    VStack {
                        Text("Members")
                            .font(.custom("Comfortaa", size: 20).weight(.bold))
                            .foregroundColor(SUColorStandartPalette.text)
                    }
                    VStack {
                        SUButtonCircular(
                            icon: "person.badge.plus",
                            action: viewModel.inviteAction
                        )
                            .frame(width: 36.0, height: 36.0)
                    }
                    .padding(.trailing, 16)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.top, 16)
                GeometryReader { scrollProxy in
                    ScrollView {
                        VStack(spacing: 40) {
                            ListItems()
                        }
                        .padding(16)
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
            // TODO: Consider adding a toolbar
//            .overlay {
//                VStack {
//                    toolbar
//                }
//                .frame(maxHeight: .infinity, alignment: .bottom)
//                .padding(.bottom, 10.0)
//            }
        }
        .onAppear(perform: viewModel.load)
    }
}

// MARK: - Private interface

private extension WorkspaceMemberScreen {

    func ListItems() -> some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(minimum: .zero, maximum: .infinity))
            ],
            spacing: 24.0
        ) {
            ForEach(viewModel.items) { item in
                SUListTileMember(
                    content: SUListTileMember.Content(
                        title: item.title,
                        imagePath: item.imagePath,
                        badges: item.badges.map { badge in
                            SUListTileMember.Badge(
                                title: badge.title,
                                icon: badge.type.icon,
                                color: badge.type.color
                            )
                        }
                    ),
                    action: {}
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
    }
}

extension WorkspaceMemberViewModel.Badge.BadgeType {

    var color: Color {
        switch self {
        case .permission:
            return .cyan.opacity(0.4)
        case .role:
            return .red.opacity(0.4)
        }
    }

    var icon: String {
        switch self {
        case .permission:
            return "gear"
        case .role:
            return "person"
        }
    }
}

struct WorkspaceMemberScreen_Previews: PreviewProvider {

    static let viewModel = WorkspaceMemberViewModel(
        appState: SUAppStateProviderMock(),
        memberManager: SUManagerMemberMock(),
        workspaceMeta: .empty
    )

    static var previews: some View {
        WorkspaceMemberScreen(
            viewModel: viewModel
        )
    }
}
