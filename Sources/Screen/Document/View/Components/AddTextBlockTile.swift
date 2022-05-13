//
//  AddTextBlockTile.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 13.05.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI
import SUDesign

struct AddTextBlockTile {
  let size: CGSize
  let action: () -> Void
}

extension AddTextBlockTile: View {
  var body: some View {
    Button {
      action()
    } label: {
      HStack(spacing: 8.0) {
        Image(systemName: "plus")
          .font(.system(size: 20.0, weight: .bold, design: .rounded))
        Text("Add text block")
          .font(.custom("Comfortaa", size: 16.0))
      }
      .foregroundColor(.gray.opacity(0.6))
      .padding(.leading, 8.0)
      .frame(
        width: size.width - 40.0,
        height: 44.0,
        alignment: .leading
      )
      .contentShape(Rectangle())
    }
    .buttonStyle(AddTextBlockButtonStyle())
  }
}

struct AddTextBlockButtonStyle: ButtonStyle {
  func makeBody(
    configuration: Configuration
  ) -> some View {
    configuration
      .label
      .opacity(configuration.isPressed ? 0.77 : 1.0)
      .animation(
        .easeInOut(duration: 0.13),
        value: configuration.isPressed
      )
  }
}

struct AddTextBlockTile_Previews: PreviewProvider {
    static var previews: some View {
      ZStack {
        SUColorStandartPalette
          .background
          .ignoresSafeArea()
        AddTextBlockTile(
          size: CGSize(
            width: 300,
            height: 50
          ),
          action: {}
        )
      }
    }
}
