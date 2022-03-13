//
//  SUManagerAccount.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 13.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine
import Foundation

public protocol SUManagerAccount {

    var invites: CurrentValueSubject<[SUShallowWorkspace], Never> { get }

    func observeInvites(for userId: String)
}

public struct SUManagerAccountMock {

    public var invites = CurrentValueSubject<[SUShallowWorkspace], Never>([])

    private let workspacesCallback: () -> [SUShallowWorkspace]

    public init(
        workspaces: @escaping () -> [SUShallowWorkspace] = { [] }
    ) {
        workspacesCallback = workspaces
    }
}

extension SUManagerAccountMock: SUManagerAccount {

    public func observeInvites(for userId: String) {
        invites.value = workspacesCallback()
    }
}
