//
//  WorkspaceViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 13.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import Combine

final class WorkspaceViewModel: ObservableObject {

    private let environment: Environment
    private var spaceManager: SpaceManager {
        environment.spaceManager
    }
    private var state: AppState {
        environment.state
    }

    init(environment: Environment = .dev) {
        self.environment = environment
    }

    
}
