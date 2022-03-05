//
//  View+.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 5.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

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
