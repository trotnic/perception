//
//  SUButtonCircularStyle.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 12.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

struct SUButtonCircularStyle: ButtonStyle {

    let radius: CGFloat
    let borderColor: Color

    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { proxy in
            configuration.label
                .padding()
                .foregroundColor(configuration.isPressed ? Color.gray : Color.teal)
                .background {
                    Circle()
                        .stroke(lineWidth: 2.0)
                        .fill(borderColor)
                        .frame(
                            width: configuration.isPressed ? proxy.size.width - radius : proxy.size.width + radius,
                            height: configuration.isPressed ? proxy.size.height - radius : proxy.size.height + radius
                        )
                }
                .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
        }
    }
}
