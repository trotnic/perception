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
    @Published public private(set) var isSignButtonActive: Bool = false

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

    func signIn() {
        Task {
            do {
                try await sessionManager.signIn(email: email, password: password)
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

    func signUp() {
        Task {
            do {
                try await sessionManager.signUp(email: email, password: password)
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
}

// MARK: - Private interface

private extension AuthenticationViewModel {

    func setupBindings() {
        $password
            .merge(with: $email)
            .map { [self] _ in
                !(email.isEmpty || password.isEmpty)
            }
            .assign(to: &$isSignButtonActive)
        $password
            .merge(with: $email)
            .drop { _ in self.errorText.isEmpty }
            .sink { _ in self.errorText = .empty }
            .store(in: &disposeBag)
    }
}
