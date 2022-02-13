//
//  AuthenticationViewModelTests.swift
//  PerceptionTests
//
//  Created by Uladzislau Volchyk on 13.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import XCTest
import SUFoundation
@testable import Perception

final class AuthenticationViewModelTests: XCTestCase {

    private var sut: AuthenticationViewModel!

    override func setUp() {
        sut = AuthenticationViewModel(
            appState: SUAppStateProviderMock(),
            userManager: SUManagerUserMock()
        )
    }

    override func tearDown() {
        sut = nil
    }

    func testEmailNotEmptyPasswordEmptySignButtonInactive() {
        sut.email = "some@email.com"

        XCTAssertFalse(sut.isSignButtonActive)
    }

    func testEmailEmptyPasswordNotEmptySignButtonInactive() {
        sut.password = "password"

        XCTAssertFalse(sut.isSignButtonActive)
    }

    func testEmailNotEmptyPasswordNotEmptySignButtonActive() {
        sut.email = "some@email.com"
        sut.password = "password"

        XCTAssertFalse(sut.isSignButtonActive)
    }
}
