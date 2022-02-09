//
//  AuthenticationScreen.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 1.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

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
            ColorProvider.background
                .ignoresSafeArea()
            VStack(spacing: proxy.size.height * 0.274) {
                VStack(alignment: .center, spacing: 64.0) {
                    Text(state == .signIn ? "Sign In" : "Sign Up")
                        .font(.system(size: 36.0, weight: .medium, design: .rounded))
                        .foregroundColor(ColorProvider.text)
                    VStack(spacing: 48.0) {
                        VStack(spacing: 24.0) {
                            TextField("", text: $viewModel.email)
                                .placeholder(when: viewModel.email.isEmpty) {
                                    Text("Enter your email...")
                                        .foregroundColor(ColorProvider.secondary1)
                                }
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .foregroundColor(ColorProvider.text)
                                .padding(.horizontal, 16.0)
                                .padding(.vertical, 15.0)
                                .background(ColorProvider.tile)
                                .cornerRadius(10.0)
                                .frame(maxWidth: proxy.size.width - 40, maxHeight: 48.0)
                            TextField("", text: $viewModel.password)
                                .placeholder(when: viewModel.password.isEmpty) {
                                    Text("Enter your password...")
                                        .foregroundColor(ColorProvider.secondary1)
                                }
                                .textInputAutocapitalization(.never)
                                .foregroundColor(ColorProvider.text)
                                .padding(.horizontal, 16.0)
                                .padding(.vertical, 15.0)
                                .background(ColorProvider.tile)
                                .cornerRadius(10.0)
                                .frame(maxWidth: proxy.size.width - 40, maxHeight: 48.0)
                        }

                        Button {
                            state == .signIn ? viewModel.signIn() : viewModel.signUp()
                        } label: {
                            Text(state == .signIn ? "Sign In" : "Sign Up")
                                .foregroundColor(ColorProvider.text)
                                .font(.system(size: 20.0, weight: .medium, design: .rounded))
                        }
                        .frame(maxWidth: proxy.size.width - 40.0, maxHeight: 56.0)
                        .background(ColorProvider.tint)
                        .cornerRadius(20.0)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, proxy.size.height * 0.16)

                HStack(spacing: 16.0) {
                    Text(state == .signIn ? "Don't have an account?" : "Already have an account?")
                        .foregroundColor(ColorProvider.secondary1)
                    Button {
                        state = state == .signUp ? .signIn : .signUp
                    } label: {
                        Text(state == .signIn ? "Sign Up" : "Sign In")
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct AuthorizationScreen_Previews: PreviewProvider {
    static let viewModel = AuthenticationViewModel(environment: .preview)

    static var previews: some View {
        AuthenticationScreen(viewModel: viewModel)
    }
}


