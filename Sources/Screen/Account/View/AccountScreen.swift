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
}

extension AccountScreen: View {

    var body: some View {
        GeometryReader { proxy in
            SUColorStandartPalette.background
                .ignoresSafeArea()
            VStack(spacing: 16.0) {

                if isEditing {
                    VStack(spacing: 32.0) {
                        Circle()
                            .frame(width: 120.0, height: 120.0)
                        VStack(spacing: 40.0) {
                            HStack {
                                SUButtonCircular(icon: "xmark") {
                                    isEditing = false
                                }
                                Spacer()
                                VStack(spacing: 12.0) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(SUColorStandartPalette.secondary2)
                                        .frame(width: 72.0, height: 4.0)
                                    Text("Edit profile")
                                }
                                .offset(y: -8.0)
                                Spacer()
                                Button {
                                    
                                } label: {
                                    Text("Reset")
                                }
                            }
                            .padding(.top, 12.0)
                            .frame(maxWidth: .infinity)

                            VStack(spacing: 48.0) {
                                VStack(alignment: .leading) {
                                    Text("Name")
                                    Text("Kek Lolman")
                                        .font(.system(size: 16.0))
                                        .padding(16.0)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(SUColorStandartPalette.tile)
                                        .cornerRadius(10.0)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
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
                                Text("Save")
                                    .font(.system(size: 20.0).weight(.bold))
                                    .foregroundColor(SUColorStandartPalette.text)
                                    .frame(maxWidth: proxy.size.width - 32)
                                    .frame(height: 56)
                                    .background(SUColorStandartPalette.tint)
                                    .cornerRadius(20.0)
                            }
                        }
                        .padding(.horizontal, 16.0)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(20.0, corners: [.topLeft, .topRight])
                    }
                    .frame(maxWidth: .infinity)
                } else {
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
                                    Text("Kek Lolman")
                                        .font(.system(size: 36.0))
                                    Text("kek.lolman@gmail.com")
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
                                .frame(maxWidth: proxy.size.width - 32)
                                .frame(height: 56)
                                .background(SUColorStandartPalette.destructive)
                                .cornerRadius(20.0)
                        }
                    }
                    .padding(.horizontal, 16.0)
                }
            }
            .foregroundColor(SUColorStandartPalette.text)
        }
    }
}

struct AccountScreen_Previews: PreviewProvider {

    static let viewModel = AccountViewModel(
        appState: SUAppStateProviderMock(),
        userManager: SUManagerUserMock()
    )

    static var previews: some View {
        AccountScreen(viewModel: viewModel)
    }
}
