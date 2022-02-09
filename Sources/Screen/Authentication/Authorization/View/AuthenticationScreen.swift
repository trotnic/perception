//
//  AuthenticationScreen.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 1.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

struct AuthenticationScreen {

    @StateObject var viewModel: AuthenticationViewModel

    @State private var email: String = ""
    @State private var password: String = ""
}

extension AuthenticationScreen: View {

    var body: some View {
        GeometryReader { proxy in
            ColorProvider.background
                .ignoresSafeArea()
            VStack(alignment: .center) {
                Text("Log in")
                    .font(.system(size: 36.0, weight: .bold, design: .rounded))
                    .foregroundColor(ColorProvider.text)
                VStack(spacing: 48.0) {
                    VStack(spacing: 24.0) {
                        TextField("", text: $email)
                            .placeholder(when: email.isEmpty) {
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
                        TextField("", text: $password)
                            .placeholder(when: password.isEmpty) {
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
                        viewModel.process(email: email, password: password)
                    } label: {
                        Text("Authorize")
                            .foregroundColor(ColorProvider.text)
                            .font(.system(size: 20.0, weight: .bold, design: .rounded))
                    }
                    .frame(maxWidth: proxy.size.width - 40.0, maxHeight: 56.0)
                    .background(ColorProvider.tint)
                    .cornerRadius(20.0)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct AuthorizationScreen_Previews: PreviewProvider {
    static let viewModel = AuthenticationViewModel(environment: .preview)

    static var previews: some View {
        AuthenticationScreen(viewModel: viewModel)
    }
}


