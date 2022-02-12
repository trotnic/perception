//
//  SUButton.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 12.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

struct SUButtonStyle: ButtonStyle {

    let escalationRadius: CGFloat
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
                        .frame(width: configuration.isPressed ? proxy.size.width - escalationRadius : proxy.size.width + escalationRadius,
                               height: configuration.isPressed ? proxy.size.height - escalationRadius : proxy.size.height + escalationRadius)
                }
                .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
        }
    }
}
