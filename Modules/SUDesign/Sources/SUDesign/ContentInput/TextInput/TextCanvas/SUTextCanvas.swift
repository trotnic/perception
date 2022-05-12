//
//  SUTextCanvas.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 19.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import SwiftUI

public struct SUTextCanvas {

  @State private var dynamicHeight: CGFloat = 44.0
  @Binding private var text: String
  @FocusState private var isFocused: Bool

  private let onStart: () -> Void
  private let onFinish: () -> Void

  private let width: CGFloat

  public init(
    text: Binding<String>,
    width: CGFloat,
    onStart: @escaping () -> Void,
    onFinish: @escaping () -> Void
  ) {
    _text = text
    self.width = width
    self.onStart = onStart
    self.onFinish = onFinish
    dynamicHeight = text.wrappedValue.height(width: width, font: .preferredFont(forTextStyle: .body))
  }
}

extension SUTextCanvas: View {

  public var body: some View {
    VStack {
#if os(iOS)
      UITextViewCanvas(
        text: $text,
        calculatedHeight: $dynamicHeight,
        width: width,
        onFinish: {
          isFocused = false
          onFinish()
        }
      )
      .frame(height: dynamicHeight)
#elseif os(macOS)
      NSTextViewCanvas(
        dynamicHeight: $dynamicHeight,
        text: $text,
        nsFont: .preferredFont(forTextStyle: .body)
      )
      .frame(height: dynamicHeight)
#endif
    }
    .focused($isFocused)
    .frame(maxWidth: .infinity, alignment: .leading)
    .contentShape(Rectangle())
    .onTapGesture {
      onStart()
      isFocused = true
    }
  }
}

// MARK: - Preview

struct SUTextCanvasPreviews: PreviewProvider {

  static var previews: some View {
    ZStack {
      SUColorStandartPalette.background
        .ignoresSafeArea()
      SUTextCanvas(
        text: .constant("Some text to check"),
        width: 300.0,
        onStart: {},
        onFinish: {}
      )
      .background(.red)
      .frame(width: .infinity, height: 40)
    }
  }
}
