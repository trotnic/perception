//
//  InviteManager.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 13.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine
import Foundation

public final class InviteManager {

    private let repository: Repository

    public init(
        repository: Repository
    ) {
        self.repository = repository
    }
}

extension InviteManager: SUManagerInvite {

    public func inviteUser(with email: String, in workspaceId: String) async throws {
        try await repository.addMember(email: email, workspaceId: workspaceId)
    }
}
