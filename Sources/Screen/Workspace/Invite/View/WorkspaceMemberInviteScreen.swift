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
}

extension WorkspaceMemberInviteScreen: View {

    public var body: some View {
        ZStack {
            SUColorStandartPalette.background
                .ignoresSafeArea()
            VStack {
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
                        Text("Members")
                            .font(.custom("Comfortaa", size: 20).weight(.bold))
                            .foregroundColor(SUColorStandartPalette.text)
                    }
                }
                .padding(.top, 16)
                Spacer()
                TextField("", text: $viewModel.email)
                    .placeholder(when: false) {
                        Text("Email to invite")
                            .foregroundColor(SUColorStandartPalette.secondary1)
                    }
                    .padding(20.0)
                    .foregroundColor(SUColorStandartPalette.text)
                    .background(SUColorStandartPalette.tile)
                    .cornerRadius(16.0)
                    .padding(.horizontal, 16.0)
                Spacer()
                Button {
                    viewModel.inviteAction()
                } label: {
                    Text("Invite")
                        .font(.system(size: 20.0).weight(.bold))
                        .foregroundColor(SUColorStandartPalette.text)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(SUColorStandartPalette.tint)
                        .cornerRadius(20.0)
                        .padding(.horizontal, 16.0)
                }
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
