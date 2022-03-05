//
//  SUAppStateProvider.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 12.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SUFoundation


public protocol SUAppStateProvider {
    func change(route: SUAppScreen)
}

public enum SUAppScreen {
    case none
    case back
    case authentication
    case account(SUUserMeta)
    case space
    case create
    case read(SUAppScreenContent)
}

public enum SUAppIntention {
    case create
    case read(String)
}

public enum SUAppScreenContent {
    case workspace(SUWorkspaceMeta)
    case document(SUDocumentMeta)
}

public struct SUAppStateProviderMock: SUAppStateProvider {
    public func change(route: SUAppScreen) {}
}
