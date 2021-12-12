//
//  PCNDocument.swift
//  
//
//  Created by Uladzislau Volchyk on 12.12.21.
//

import Foundation

public struct Document: Codable {
    public let id: String
    public var title: String
    public var timestamp: TimeInterval = Date().timeIntervalSince1970
}
