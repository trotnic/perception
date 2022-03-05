//
//  AccountScreen.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 8.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI
import SUDesign
import SUFoundation

struct AccountScreen {

    @StateObject var viewModel: AccountViewModel
    @State private var isEditing = false

    @FocusState private var nameIsFocused: Bool
    @Namespace var namespace
}

extension AccountScreen: View {

    var body: some View {
        GeometryReader { proxy in
            SUColorStandartPalette.background
                .ignoresSafeArea()
            VStack(spacing: 16.0) {
                if isEditing {
                    editingBlock(size: proxy.size)
                } else {
                    generalBlock(size: proxy.size)
                }
            }
            .foregroundColor(SUColorStandartPalette.text)
        }
        .onAppear(perform: viewModel.load)
    }
}

private extension AccountScreen {

    @ViewBuilder func editingBlock(size: CGSize) -> some View {
        VStack(spacing: 32.0) {
            Circle()
                .frame(width: 120.0, height: 120.0)

            Sheet(height: size.height * 0.6108374384)
                .padding(.horizontal, 16.0)

            Button {
                viewModel.saveAction()
            } label: {
                Text("Save")
                    .font(.system(size: 20.0).weight(.bold))
                    .foregroundColor(SUColorStandartPalette.text)
                    .frame(maxWidth: size.width - 32)
                    .frame(height: 56)
                    .background(SUColorStandartPalette.tint)
                    .cornerRadius(20.0)
            }
            .matchedGeometryEffect(id: "bottom_button", in: namespace)
        }
        .frame(maxWidth: .infinity)
        .onTapGesture {
            withAnimation {
                nameIsFocused = false
            }
        }
    }

    @ViewBuilder func generalBlock(size: CGSize) -> some View {
        ZStack {
            VStack {
                SUButtonCircular(icon: "chevron.left", action: viewModel.backAction)
                    .frame(width: 36.0, height: 36.0)
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.top, 16)
        VStack(spacing: 32.0) {
            Circle()
                .frame(width: 120.0, height: 120.0)
            VStack(spacing: 40.0) {
                VStack(spacing: 24.0) {
                    VStack(spacing: 16.0) {
                        Text(viewModel.username)
                            .font(.system(size: 36.0))
                        Text(viewModel.email)
                            .font(.system(size: 14.0))
                    }
                    SUButtonStroke(text: "Edit profile") {
                        withAnimation {
                            isEditing = true
                        }
                    }
                }
            }
            Spacer()
            Button {
                viewModel.logoutAction()
            } label: {
                Text("Log out")
                    .font(.system(size: 20.0).weight(.bold))
                    .foregroundColor(SUColorStandartPalette.text)
                    .frame(maxWidth: size.width - 32)
                    .frame(height: 56)
                    .background(SUColorStandartPalette.destructive)
                    .cornerRadius(20.0)
            }
            .matchedGeometryEffect(id: "bottom_button", in: namespace)
        }
        .padding(.horizontal, 16.0)
    }

    func Sheet(height: CGFloat) -> some View {
        ZStack {
            VStack(spacing: .zero) {
                HStack {
                    SUButtonCircular(icon: "xmark", action: {
                        withAnimation {
                            isEditing = false
                        }
                    })
                        .frame(width: 36.0, height: 36.0)
                        .padding(.vertical, 20.0)
                    Spacer()
                    VStack {
                        RoundedRectangle(cornerRadius: 10.0)
                            .fill(SUColorStandartPalette.secondary2)
                            .frame(width: 72.0, height: 4.0)
                        Text("Edit profile")
                            .font(.system(size: 18.0))
                            .foregroundColor(SUColorStandartPalette.text)
                    }

                    Spacer()
                    SUButtonStroke(text: "Reset") {
                        viewModel.resetAction()
                    }
                }
                .padding(.horizontal, 16.0)

                ScrollView {
                    VStack(spacing: 24.0) {
                        VStack(alignment: .leading, spacing: 16.0) {
                            Text("Name")
                                .font(.system(size: 16.0, weight: .bold))
                                .foregroundColor(SUColorStandartPalette.secondary1)
                            SUTextFieldCapsule(
                                text: $viewModel.username,
                                placeholder: "Start typing"
                            )
                        }
                        .padding(.horizontal, 16.0)
                        Spacer()
                    }
                }
                .padding(.vertical, 20.0)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .background(SUColorStandartPalette.background)
        .cornerStroke(
            20.0,
            corners: .allCorners,
            color: SUColorStandartPalette.tile
        )
    }
}

struct AccountScreenSS_Previews: PreviewProvider {

    static let viewModel = AccountViewModel(
        appState: SUAppStateProviderMock(),
        userManager: SUManagerUserPrimeMock(
            userId: { .empty },
            isAuthenticated: { false },
            user: {
                SUUser(
                    meta: .init(id: .empty),
                    username: "lol kekman",
                    email: "lol.kekman@gmail.com"
                )
            }
        ),
        userMeta: .empty
    )

    static var previews: some View {
        ZStack {
            AccountScreen(viewModel: viewModel)
        }
    }
}
