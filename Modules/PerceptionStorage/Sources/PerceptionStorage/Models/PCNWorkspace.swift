//
//  PCNWorkspace.swift
//  
//
//  Created by Uladzislau Volchyk on 12.12.21.
//

import Foundation

public struct Workspace: Codable {
    public let id: String
    public var shelfs: [Shelf]
    public let timestamp: TimeInterval
}
