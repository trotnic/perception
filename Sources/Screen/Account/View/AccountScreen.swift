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
    @State private var isEditing = true

    @FocusState private var nameIsFocused: Bool
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
            SUSheet(
                height: size.height * 0.6108374384,
                title: "Edit profile",
                content: {
                    [
                        SUSheet.SUSheetItem(
                            title: "Name",
                            placeholder: "Some text",
                            text: .constant("Uladzislau Volchyk")
                        )
                    ]
                }
            )
                .padding(.horizontal, 16.0)
                .focused($nameIsFocused)
            Button {
                viewModel.logoutAction()
            } label: {
                Text("Save")
                    .font(.system(size: 20.0).weight(.bold))
                    .foregroundColor(SUColorStandartPalette.text)
                    .frame(maxWidth: size.width - 32)
                    .frame(height: 56)
                    .background(SUColorStandartPalette.tint)
                    .cornerRadius(20.0)
            }
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
                    Button {
                        isEditing = true
                    } label: {
                        Text("Edit profile")
                            .font(.system(size: 14.0))
                    }
                }

                VStack(alignment: .leading) {
                    Text("Title")
                    Text("Software Engineer")
                        .font(.system(size: 16.0))
                        .padding(16.0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(SUColorStandartPalette.tile)
                        .cornerRadius(10.0)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
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
        }
        .padding(.horizontal, 16.0)
    }
}

struct AccountScreen_Previews: PreviewProvider {

    static let viewModel = AccountViewModel(
        appState: SUAppStateProviderMock(),
        userManager: SUManagerUserPrimeMock(
            userId: { .empty },
            isAuthenticated: { true },
            user: {
                SUUser(
                    meta: .init(id: .empty),
                    username: "lol kekman",
                    email: "lol.kekman@gmail.com"
                )
            }
        ),
        userMeta: .init(id: .empty)
    )

    static var previews: some View {
        AccountScreen(viewModel: viewModel)
    }
}
