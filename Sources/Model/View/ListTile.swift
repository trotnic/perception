//
//  ListTile.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 17.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public struct ListTileViewItem: Identifiable {
    public var id: String = UUID().uuidString
    public let iconText: String
    public let title: String
//    public let membersTitle: String
//    public let lastEditTitle: String
}
