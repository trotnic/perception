//
//  SUButtonCapsuleStyle.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 12.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

struct SUButtonCapsuleStyle: ButtonStyle {

  let isActive: Bool
  let size: CGSize
  let cornerRadius: CGFloat

  public init(isActive: Bool, size: CGSize, cornerRadius: CGFloat = 20.0) {
    self.isActive = isActive
    self.size = size
    self.cornerRadius = cornerRadius
  }

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .foregroundColor(
        foregroundColor(
          isActive: isActive,
          isPressed: configuration.isPressed
        )
      )
      .frame(
        width: size.width,
        height: size.height
      )
      .background(
        backgroundColor(
          isActive: isActive,
          isPressed: configuration.isPressed
        )
      )
      .cornerRadius(cornerRadius)
      .animation(
        .easeInOut(duration: 0.12),
        value: configuration.isPressed
      )
  }
}

private extension SUButtonCapsuleStyle {

  func foregroundColor(isActive: Bool, isPressed: Bool) -> Color {
    guard isActive else { return SUColorStandartPalette.secondary1 }
    guard isPressed else { return SUColorStandartPalette.text }
    return SUColorStandartPalette.text.opacity(0.5)
  }

  func backgroundColor(isActive: Bool, isPressed: Bool) -> Color {
    guard isActive else { return SUColorStandartPalette.secondary3 }
    guard isPressed else { return SUColorStandartPalette.tint }
    return SUColorStandartPalette.tint.opacity(0.5)
  }
}
