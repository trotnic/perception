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

  enum InputItem {
    case email
    case password
  }

  @StateObject var viewModel: AuthenticationViewModel
  @FocusState var focusNode: InputItem?
}

extension AuthenticationScreen: View {

  var body: some View {
    NavigationView {
      GeometryReader { proxy in
        SUColorStandartPalette.background
          .ignoresSafeArea()
        VStack(spacing: proxy.size.height * 0.274) {
          VStack(
            alignment: .center,
            spacing: 64.0
          ) {
            Text(viewModel.state.signButtonTitle)
              .font(.custom("Cofmortaa", size: 36.0).weight(.medium))
              .foregroundColor(SUColorStandartPalette.text)
            VStack(spacing: 24.0) {
              VStack(
                alignment: .leading,
                spacing: 8.0
              ) {
                Fields()
                Text(viewModel.errorText)
                  .font(.custom("Cofmortaa", size: 14.0).bold())
                  .foregroundColor(SUColorStandartPalette.destructive)
                  .padding(.leading, 8.0)
                  .opacity(viewModel.errorText.isEmpty ? 0.0 : 1.0)
                  .frame(height: 16.0)
              }
              SUButtonCapsule(
                isActive: $viewModel.isSignButtonActive,
                title: viewModel.state.signButtonTitle,
                size: CGSize(
                  width: proxy.size.width - 40.0,
                  height: 56.0
                ),
                action: viewModel.signButtonAction
              )
            }
          }
          .frame(maxWidth: .infinity)
          .padding(.top, proxy.size.height * 0.16)
          HStack(
            spacing: 16.0
          ) {
            Text(viewModel.state.changeStateButtonDescription)
              .foregroundColor(SUColorStandartPalette.secondary1)
            Button(action: viewModel.toggleStateAction) {
              Text(viewModel.state.signButtonTitle)
            }
            .disabled(!viewModel.isSwapButtonActive)
          }
          .frame(maxWidth: .infinity)
          .padding(.horizontal, 22.0)
        }
      }
      #if os(iOS)
      .navigationBarHidden(true)
      #endif
    }
  }
}

private extension AuthenticationScreen {

  func Fields() -> some View {
    VStack(spacing: 24.0) {
      SUTextFieldCapsule(
        text: $viewModel.email,
        placeholder: "Enter your email"
      )
      .disabled(!viewModel.isEmailFieldActive)
      .focused($focusNode, equals: .email)
      .frame(maxWidth: .infinity)
      .padding(.horizontal, 22.0)
      .onTapGesture {
        focusNode = .email
      }
      SUSecureTextFieldCapsule(
        text: $viewModel.password,
        placeholder: "Enter your password"
      )
      .disabled(!viewModel.isPasswordFieldActive)
      .focused($focusNode, equals: .password)
      .frame(maxWidth: .infinity)
      .padding(.horizontal, 22.0)
      .onTapGesture {
        focusNode = .password
      }
    }
#if os(iOS)
    .textInputAutocapitalization(.never)
    .toolbar {
      ToolbarItemGroup(placement: .keyboard) {
        HStack {
          Spacer()
          Button {
            focusNode = nil
          } label: {
            Image(systemName: "keyboard.chevron.compact.down")
          }
        }
      }
    }
#endif
  }
}

extension AuthenticationViewModel.AuthState {

  var signButtonTitle: String {
    switch self {
      case .signIn:
        return "Sign In"
      case .signUp:
        return "Sign Up"
    }
  }

  var changeStateButtonDescription: String {
    switch self {
      case .signIn:
        return "Don't have an account?"
      case .signUp:
        return "Already have an account?"
    }
  }

  var changeStateButtonTitle: String {
    switch self {
      case .signIn:
        return "Sign Up"
      case .signUp:
        return "Sign In"
    }
  }
}

// MARK: - Preview

struct AuthorizationScreen_Previews: PreviewProvider {
  static let viewModel = AuthenticationViewModel(
    appState: SUAppStateProviderMock(),
    sessionManager: SUManagerUserPrimeMock()
  )

  static var previews: some View {
    AuthenticationScreen(
      viewModel: viewModel
    )
  }
}
