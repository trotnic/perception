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
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(
                width: radius,
                height: radius
            )
        )
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
