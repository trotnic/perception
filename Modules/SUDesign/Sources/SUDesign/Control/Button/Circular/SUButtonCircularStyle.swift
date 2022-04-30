//
//  SUButtonCircularStyle.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 12.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

struct SUButtonCircularStyle: ButtonStyle {

  func makeBody(configuration: Configuration) -> some View {
    GeometryReader { proxy in
      configuration.label
//        .padding(10.0)
        .foregroundColor(
          configuration.isPressed ?
          SUColorStandartPalette.secondary1 : SUColorStandartPalette.text
        )
        .background {
          Circle()
            .stroke(lineWidth: 2.0)
            .fill(
              configuration.isPressed ?
              SUColorStandartPalette.secondary3 : SUColorStandartPalette.secondary2
            )
        }
        .contentShape(Circle())
        .frame(
          width: proxy.size.width,
          height: proxy.size.height
        )
        .scaleEffect(configuration.isPressed ? 0.78 : 1.0)
        .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
  }
}
