//
//  SUExpandableBlock.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 17.04.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import SwiftUI

public struct SUExpandableBlock {
  @State private var rect: CGRect = .zero
  @State private var isOverlayShown = false
  @State private var isHover = false
}

extension SUExpandableBlock: View {
  public var body: some View {
    Button {
      isOverlayShown.toggle()
    } label: {
      Text("lolkek")
        .foregroundColor(SUColorStandartPalette.text)
        .frame(maxWidth: .infinity)
        .frame(height: 200.0)
        .background {
          Color.purple.opacity(0.1)
        }
        .overlay {
          GeometryReader { imageReader in
            Color.clear
              .preference(
                key: SUFrameKey.self,
                value: imageReader.frame(in: .global)
              )
              .onPreferenceChange(SUFrameKey.self) { rect = $0 }
          }
        }
    }
    .buttonStyle(SUExpandableButtonStyle())
    .frame(maxWidth: .infinity)
    .frame(height: 200.0)
    .background {
      if isOverlayShown {
        Rectangle()
          .stroke(.yellow)
          .offset(x: .zero, y: rect.height)
          .transition(.opacity.animation(.easeIn(duration: 0.15)))
      }
    }
  }
}

private struct SUExpandableButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration
      .label
      .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
      .animation(.easeInOut, value: configuration.isPressed)
  }
}

// swiftlint:disable type_name
struct SUExpandableBlock_Preview: PreviewProvider {
  static var previews: some View {
    ZStack {
      SUColorStandartPalette
        .background
        .ignoresSafeArea()
      SUExpandableBlock()
//        .cornerRadius(20.0)
    }
  }
}
