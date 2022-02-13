//
//  AuthenticationScreen.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 1.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI
import SUFoundation
import SUDesign

struct AuthenticationScreen {

    private enum AuthState {
        case signIn
        case signUp
    }

    @StateObject var viewModel: AuthenticationViewModel

    @State private var state: AuthState = .signIn
}

extension AuthenticationScreen: View {

    var body: some View {
        GeometryReader { proxy in
            SUColorStandartPalette.background
                .ignoresSafeArea()
            VStack(spacing: proxy.size.height * 0.274) {
                VStack(alignment: .center, spacing: 64.0) {
                    Text(state == .signIn ? "Sign In" : "Sign Up")
                        .font(.system(size: 36.0, weight: .medium, design: .rounded))
                        .foregroundColor(SUColorStandartPalette.text)
                    VStack(spacing: 24.0) {
                        VStack(alignment: .leading, spacing: 8.0) {
                            VStack(spacing: 24.0) {
                                SUTextFieldCapsule(
                                    text: $viewModel.email,
                                    placeholder: "Enter your email"
                                )
                                    .frame(maxWidth: proxy.size.width - 44.0)
                                SUTextFieldCapsule(
                                    text: $viewModel.password,
                                    placeholder: "Enter your password"
                                )
                                    .frame(maxWidth: proxy.size.width - 44.0)
                            }
                            .textInputAutocapitalization(.never)
                            Text(viewModel.errorText)
                                .font(.system(size: 14.0).bold())
                                .foregroundColor(SUColorStandartPalette.destructive)
                                .padding(.leading, 8.0)
                                .opacity(viewModel.errorText.isEmpty ? 0.0 : 1.0)
                                .frame(height: 16.0)
                        }
                        SUButtonCapsule(
                            isActive: viewModel.isSignButtonActive,
                            title: state == .signIn ? "Sign In" : "Sign Up",
                            size: CGSize(width: proxy.size.width - 40.0, height: 56.0)
                        ) {
                            state == .signIn ? viewModel.signIn() : viewModel.signUp()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, proxy.size.height * 0.16)

                HStack(spacing: 16.0) {
                    Text(state == .signIn ? "Don't have an account?" : "Already have an account?")
                        .foregroundColor(SUColorStandartPalette.secondary1)
                    Button {
                        state = state == .signUp ? .signIn : .signUp
                    } label: {
                        Text(state == .signIn ? "Sign Up" : "Sign In")
                    }
                }
                .frame(maxWidth: proxy.size.width - 44.0)
            }
        }
    }
}

struct AuthorizationScreen_Previews: PreviewProvider {
    static let viewModel = AuthenticationViewModel(
        appState: SUAppStateProviderMock(),
        userManager: SUManagerUserMock()
    )

    static var previews: some View {
        AuthenticationScreen(
            viewModel: viewModel
        )
    }
}
