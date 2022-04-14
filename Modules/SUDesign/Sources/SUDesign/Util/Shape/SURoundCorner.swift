//
//  SURoundCorner.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 10.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

struct SURoundCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        #if os(iOS)
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(
                width: radius,
                height: radius
            )
        )
        #elseif os(macOS)
        let path = NSBezierPath(
            roundedRect: NSRect(
                origin: rect.origin,
                size: rect.size
            ),
            xRadius: radius,
            yRadius: radius
        )
        #endif
        return Path(path.cgPath)
    }
}

struct SURoundCorner_Previews: PreviewProvider {
    static var previews: some View {
        Color.red
            .frame(width: 40, height: 40)
            .cornerRadius(20, corners: [.topLeft, .bottomRight])
    }
}

extension NSBezierPath {
    
    /// A `CGPath` object representing the current `NSBezierPath`.
    var cgPath: CGPath {
        let path = CGMutablePath()
        let points = UnsafeMutablePointer<NSPoint>.allocate(capacity: 3)

        if elementCount > 0 {
            var didClosePath = true

            for index in 0..<elementCount {
                let pathType = element(at: index, associatedPoints: points)

                switch pathType {
                case .moveTo:
                    path.move(to: points[0])
                case .lineTo:
                    path.addLine(to: points[0])
                    didClosePath = false
                case .curveTo:
                    path.addCurve(to: points[2], control1: points[0], control2: points[1])
                    didClosePath = false
                case .closePath:
                    path.closeSubpath()
                    didClosePath = true
                @unknown default:
                    break
                }
            }

            if !didClosePath { path.closeSubpath() }
        }

        points.deallocate()
        return path
    }
}
