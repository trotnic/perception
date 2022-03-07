//
//  MemberManager.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 7.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine
import Foundation

public final class MemberManager: ObservableObject {

    public var members = CurrentValueSubject<[SUWorkspaceMember], Never>([])

    private let repository: Repository

    public init(
        repository: Repository
    ) {
        self.repository = repository
    }

    deinit {
//        repository.stopListen(with: workspaceMeta.id)
    }
}

extension MemberManager: SUManagerMember {

    public func members(id workspaceId: String) {
        repository.members(workspaceId: workspaceId) { members in
            Task {
                await MainActor.run {
                    self.members.value = members
                }
            }
        }
    }
}
