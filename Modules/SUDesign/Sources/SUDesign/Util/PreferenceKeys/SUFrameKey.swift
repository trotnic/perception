//
//  SUFrameKey.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 20.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

public struct SUFrameKey: PreferenceKey {
    public static var defaultValue: CGRect = .zero

    public static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
