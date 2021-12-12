//
//  PCNDesignHolder.swift
//  
//
//  Created by Uladzislau Volchyk on 11.12.21.
//

import UIKit

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

public protocol PCNColorScheme {
    var background: Int { get }
    var tile: Int { get }
    var highlighter: Int { get }
    var destructive: Int { get }
    var tint: Int { get }
    var text: Int { get }
    var highlight1: Int { get }
    var highlight2: Int { get }
    var highlight3: Int { get }
    var highlight4: Int { get }
}

public struct PCNDefaultColorScheme: PCNColorScheme {
    public let background: Int = 0x171A1F
    public let tile: Int = 0x272A33
    public let highlighter: Int = 0x555C73
    public let destructive: Int = 0xD84940
    public let tint: Int = 0x1F50FF
    public let text: Int = 0xFEFFFF
    public let highlight1: Int = 0x523768
    public let highlight2: Int = 0x683737
    public let highlight3: Int = 0x376568
    public let highlight4: Int = 0x684937
}

public final class PCNDesignHolder {

    static let scheme = PCNDefaultColorScheme()

    public static func color(_ of: KeyPath<PCNDefaultColorScheme, Int>) -> UIColor {
        UIColor(rgb: scheme[keyPath: of])
    }
}
