//
//  View+.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 5.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI
#if os(macOS)
public struct NSRectCorner: OptionSet {
    public typealias RawValue = Int
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let none: NSRectCorner = []
    public static let topLeft = NSRectCorner(1 << 0)
    public static let topRight = NSRectCorner(1 << 1)
    public static let bottomLeft = NSRectCorner(1 << 2)
    public static let bottomRight = NSRectCorner(1 << 3)
    public static let allCorners: NSRectCorner = [.topLeft, .topLeft, .bottomLeft, .bottomRight]
}
public typealias UIRectCorner = NSRectCorner
#endif

public extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(
            SURoundCorner(
                radius: radius,
                corners: corners
            )
        )
    }

    func cornerStroke(_ radius: CGFloat, corners: UIRectCorner, color: Color) -> some View {
        overlay(
            SURoundCorner(
                radius: radius,
                corners: corners
            )
                .stroke(color)
        )
    }

    func cornerStroke<Content: ShapeStyle>(_ radius: CGFloat, corners: UIRectCorner, content: Content) -> some View {
        overlay(
            SURoundCorner(
                radius: radius,
                corners: corners
            )
                .stroke(content)
        )
    }
}
