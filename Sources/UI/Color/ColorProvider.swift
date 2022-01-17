//
//  ColorProvider.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 15.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

public enum ColorProvider {

    static let text = Color(hex: "FEFFFF")

    static let background = Color(hex: "171A1F")
    static let tile = Color(hex: "272A33")

    static let tint = Color(hex: "1F50FF")
    static let destructive = Color(hex: "D84940")
    static let confirmation = Color(hex: "316672")

    static let redOutline = Color(hex: "683737")
    static let yellowOutline = Color(hex: "684937")
    static let greenOutline = Color(hex: "376568")
    static let purpleOutline = Color(hex: "523768")

    static let secondary1 = Color(hex: "A3A8BB")
    static let secondary2 = Color(hex: "555C73")
    static let secondary3 = Color(hex: "4D505B")
}
