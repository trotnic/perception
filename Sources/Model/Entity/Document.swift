//
//  Document.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 9.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public struct SUDocument: Identifiable {
    public let id: UUID
    public let shelfId: UUID
    public let title: String
    public let lastEditTime: Date
}
