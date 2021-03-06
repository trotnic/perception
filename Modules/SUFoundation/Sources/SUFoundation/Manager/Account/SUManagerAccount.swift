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
    func confirmInvite(userId: String, workspaceId: String)
    func rejectInvite(userId: String, workspaceId: String)
}

public struct SUManagerAccountMock {

    public let invites = CurrentValueSubject<[SUShallowWorkspace], Never>([])

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

    public func confirmInvite(userId: String, workspaceId: String) {}
    public func rejectInvite(userId: String, workspaceId: String) {}
}
