//
//  Alignment+.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 7.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

extension VerticalAlignment {

    private enum MyVerticalAlignment: AlignmentID {
        static func defaultValue(in dimension: ViewDimensions) -> CGFloat { dimension[.bottom] }
    }

    static let bottomVetical = VerticalAlignment(MyVerticalAlignment.self)
}

extension HorizontalAlignment {

    private enum MyHorizontalAlignment: AlignmentID {
        static func defaultValue(in dimension: ViewDimensions) -> CGFloat { dimension[HorizontalAlignment.center] }
    }

    static let centerHorizontal = HorizontalAlignment(MyHorizontalAlignment.self)
}

extension Alignment {
    static let centerBottom = Alignment(horizontal: .centerHorizontal, vertical: .bottomVetical)
}
