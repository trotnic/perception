//
//  ListTile.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 17.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

struct ListTileViewItem: Identifiable {
    let id = UUID()
    let iconText: String
    let title: String
    let membersTitle: String
    let lastEditTitle: String
}
