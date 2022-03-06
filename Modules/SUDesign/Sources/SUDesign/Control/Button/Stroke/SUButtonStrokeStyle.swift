//
//  SUButtonStrokeStyle.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 5.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

struct SUButtonStrokeStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding(.vertical, 8.0)
            .padding(.horizontal, 10.0)
            .cornerStroke(
                20.0,
                corners: .allCorners,
                color: SUColorStandartPalette.secondary2
            )
            .scaleEffect(configuration.isPressed ? 0.78 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
        
    }
}
