//
//  SUButtonEmoji.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 8.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

public struct SUButtonEmoji {

  @Binding private var text: String
  private let commitCallback: () -> Void
  private let onStart: () -> Void

  @FocusState private var isFocused: Bool

  public init(
    text: Binding<String>,
    commit: @escaping () -> Void,
    onStart: @escaping () -> Void
  ) {
    _text = text
    commitCallback = commit
    self.onStart = onStart
  }
}

extension SUButtonEmoji: View {

  public var body: some View {
    ZStack {
#if os(iOS)
      SUEmojiTextField(
        text: $text,
        commit: commitCallback,
        onFinish: {
          isFocused = false
        }
      )
      .focused($isFocused)
      .background(.blue.opacity(0.2))
      .frame(width: 24.0, height: 24.0)
      .padding(.zero)
      .opacity(0.01)
#endif
      if text.isEmpty {
        Image(systemName: "pencil.and.outline")
          .foregroundColor(SUColorStandartPalette.secondary2)
      } else {
        Text(text)
      }
    }
    .foregroundColor(SUColorStandartPalette.text)
    .onTapGesture {
      onStart()
      isFocused = true
    }
  }
}

// MARK: - Preview

struct SUButtonEmoji_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      SUColorStandartPalette
        .background
        .ignoresSafeArea()
      SUButtonEmoji(
        text: .constant("🔥"),
        commit: {},
        onStart: {}
      )
        .frame(width: 24.0, height: 24.0)
    }
  }
}
