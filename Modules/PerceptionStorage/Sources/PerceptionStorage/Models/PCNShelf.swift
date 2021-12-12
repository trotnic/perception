//
//  PCNShelf.swift
//  
//
//  Created by Uladzislau Volchyk on 12.12.21.
//

import Foundation

public struct Shelf: Codable {
    public let id: String
    public var documents: [Document]
    public var timestamp: TimeInterval = Date().timeIntervalSince1970
}
