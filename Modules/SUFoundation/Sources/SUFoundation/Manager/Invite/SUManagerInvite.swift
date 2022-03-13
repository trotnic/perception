//
//  SUManagerInvite.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 13.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public protocol SUManagerInvite {

    func inviteUser(with email: String, in workspaceId: String) async throws
}

public struct SUmanagerInviteMock {

    public init() {}
}

extension SUmanagerInviteMock: SUManagerInvite {

    public func inviteUser(with email: String, in workspaceId: String) async throws {}
}
