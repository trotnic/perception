//
//  WorkspaceMemberInviteScreen.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 13.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI
import SUDesign
import SUFoundation

public struct WorkspaceMemberInviteScreen {

    @StateObject var viewModel: WorkspaceMemberInviteViewModel
    @FocusState private var textFieldFocus
}

extension WorkspaceMemberInviteScreen: View {

    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                SUColorStandartPalette.background
                    .ignoresSafeArea()
                VStack(spacing: 24.0) {
                    ZStack {
                        VStack {
                            SUButtonCircular(
                                icon: "chevron.left",
                                action: {}
                            )
                                .frame(width: 36.0, height: 36.0)
                        }
                        .padding(.leading, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        VStack {
                            Text("Invite new member")
                                .font(.custom("Comfortaa", size: 20).bold())
                                .foregroundColor(SUColorStandartPalette.text)
                        }
                    }
                    .padding(.top, 16)
                    VStack(spacing: 32.0) {
                        TopTile()
                            .frame(maxWidth: proxy.size.width - 32.0)
                        SUButtonCapsule(
                            isActive: $viewModel.isInviteButtonActive,
                            title: "Send invite",
                            size: CGSize(
                                width: proxy.size.width - 32.0,
                                height: 56.0
                            ),
                            action: viewModel.inviteAction
                        )
                        .animation(.easeInOut(duration: 0.12), value: viewModel.isInviteButtonActive)
                        Text("A user will receive an invitation to your current workspace")
                            .foregroundColor(SUColorStandartPalette.secondary1)
                            .font(.custom("Cofmortaa", size: 22.0).bold())
                            .frame(maxWidth: proxy.size.width - 60.0)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .onTapGesture {
            withAnimation {
                textFieldFocus = false
            }
        }
        .onAppear {
            Task {
                try await Task.sleep(nanoseconds: 300000000)
                await MainActor.run {
                    withAnimation {
                        textFieldFocus = true
                    }
                }
            }
        }
    }
}

private extension WorkspaceMemberInviteScreen {

    @ViewBuilder
    func TopTile() -> some View {
        VStack(alignment: .leading, spacing: 16.0) {
            TextField(String.empty, text: $viewModel.email)
                .placeholder(when: viewModel.email.isEmpty) {
                    Text("Email")
                        .foregroundColor(SUColorStandartPalette.secondary1)
                }
                .focused($textFieldFocus)
        }
        .foregroundColor(SUColorStandartPalette.text)
        .padding(16.0)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            SUColorStandartPalette.tile
        }
        .mask {
            RoundedRectangle(cornerRadius: 10.0)
        }
        .onTapGesture {
            withAnimation {
                textFieldFocus = true
            }
        }
    }
}

struct WorkspaceMemberInviteScreen_Previews: PreviewProvider {

    static let viewModel = WorkspaceMemberInviteViewModel(
        appState: SUAppStateProviderMock(),
        inviteManager: SUmanagerInviteMock(),
        workspaceMeta: .empty
    )

    static var previews: some View {
        ZStack {
            SUColorStandartPalette.background
                .ignoresSafeArea()
            WorkspaceMemberInviteScreen(
                viewModel: viewModel
            )
        }
    }
}
