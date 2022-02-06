//
//  ShelfCreateViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 6.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public final class ShelfCreateViewModel: ObservableObject {

    private let environment: Environment

    private var userSession: UserSession {
        environment.userSession
    }

    public init(environment: Environment = .dev) {
        self.environment = environment
    }

}

public extension ShelfCreateViewModel {
    func backAction() {
        
    }

    func createAction() {
        
    }
}
