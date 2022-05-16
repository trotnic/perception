//
//  AuthorizationViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 1.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine
import Foundation
import SUFoundation
    
public final class AuthenticationViewModel: ObservableObject {

  @Published public var email: String = .empty
  @Published public var password: String = .empty
  @Published public var errorText: String = .empty

  @Published public var isEmailFieldActive: Bool = true
  @Published public var isPasswordFieldActive: Bool = true
  @Published public var isSignButtonActive: Bool = false
  @Published public var isSwapButtonActive: Bool = true

  @Published public var state: AuthState = .signIn

  public enum AuthState {
    case signIn
    case signUp
  }

  private var disposeBag = Set<AnyCancellable>()

  private let appState: SUAppStateProvider
  private let sessionManager: SUManagerSession

  public init(
    appState: SUAppStateProvider,
    sessionManager: SUManagerSession
  ) {
    self.appState = appState
    self.sessionManager = sessionManager
    setupBindings()
  }
}

// MARK: - Public interface

public extension AuthenticationViewModel {

  func toggleStateAction() {
    resetState()
    state = state == .signIn ? .signUp : .signIn
  }

  func signButtonAction() {
    switch state {
      case .signIn:
        signInAction()
      case .signUp:
        signUpAction()
    }
  }
}

// MARK: - Private interface

private extension AuthenticationViewModel {

  func setupBindings() {
    Publishers
      .CombineLatest(
        $email,
        $password
      )
      .receive(on: DispatchQueue.global(qos: .userInitiated))
      .map { $0.0.isValidEmail && !$0.1.isEmpty }
      .combineLatest(appState.isNetworkAvailable)
      .map { $1 ? $0 : false}
      .receive(on: DispatchQueue.main)
      .assign(to: &$isSignButtonActive)

    Publishers
      .Merge(
        $password,
        $email
      )
      .drop { _ in self.errorText.isEmpty }
      .sink { _ in self.errorText = .empty }
      .store(in: &disposeBag)

    appState
      .isNetworkAvailable
      .removeDuplicates()
      .sink { [self] in
        isEmailFieldActive = $0
        isPasswordFieldActive = $0
        isSwapButtonActive = $0
        errorText = $0 ? .empty : "No internet connection"
      }
      .store(in: &disposeBag)
  }

  func signInAction() {
    Task {
      do {
        try await sessionManager.signIn(
          email: email,
          password: password
        )
        await MainActor.run {
          appState.change(route: .space)
        }
      } catch {
        await MainActor.run {
          errorText = "Invalid email or password"
        }
      }
    }
  }

  func signUpAction() {
    Task {
      do {
        try await sessionManager.signUp(
          email: email,
          password: password
        )
        await MainActor.run {
          appState.change(route: .space)
        }
      } catch {
        await MainActor.run {
          errorText = "Error occured. Try again"
        }
      }
    }
  }

  func resetState() {
    email = .empty
    password = .empty
    errorText = .empty
  }
}
