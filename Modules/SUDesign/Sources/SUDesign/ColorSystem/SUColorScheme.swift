//
//  SUButtonCircular.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 12.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

public protocol SUColorScheme {

    static var text: Color { get }

    static var background: Color { get }
    static var tile: Color { get }

    static var tint: Color { get }
    static var destructive: Color { get }
    static var confirmative: Color { get }

    static var redOutline: Color { get }
    static var yellowOutline: Color { get }
    static var greenOutline: Color { get }
    static var purpleOutline: Color { get }

    static var secondary1: Color { get }
    static var secondary2: Color { get }
    static var secondary3: Color { get }
}

// MARK: - Default palette

public struct SUColorStandartPalette: SUColorScheme {

    public static let text = Color("text", bundle: .module)

    public static let background = Color("background", bundle: .module)
    public static let tile = Color("tile", bundle: .module)

    public static let tint = Color("tint", bundle: .module)
    public static let destructive = Color("destructive", bundle: .module)
    public static let confirmative = Color("confirmative", bundle: .module)

    public static let redOutline = Color(hex: "683737")
    public static let yellowOutline = Color(hex: "684937")
    public static let greenOutline = Color(hex: "376568")
    public static let purpleOutline = Color(hex: "523768")

    public static let secondary1 = Color("secondary1", bundle: .module)
    public static let secondary2 = Color("secondary2", bundle: .module)
    public static let secondary3 = Color("secondary3", bundle: .module)
}
