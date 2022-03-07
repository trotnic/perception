//
//  SUManagerMember.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 7.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine
import Foundation

public protocol SUManagerMember {

    var members: CurrentValueSubject<[SUWorkspaceMember], Never> { get }

    func members(id workspaceId: String)
}

public struct SUManagerMemberMock {

    public private(set) var members = CurrentValueSubject<[SUWorkspaceMember], Never>([])

    private let membersCallback: () -> [SUWorkspaceMember]

    public init(
        members: @escaping () -> [SUWorkspaceMember] = { [] }
    ) {
        membersCallback = members
    }
}

extension SUManagerMemberMock: SUManagerMember {

    public func members(id workspaceId: String) {
        self.members.value = membersCallback()
    }
}
