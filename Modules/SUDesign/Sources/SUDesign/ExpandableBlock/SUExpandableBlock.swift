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
}

extension SUExpandableBlock: View {
  public var body: some View {
    Text(NSCoder.string(for: rect))
      .foregroundColor(SUColorStandartPalette.text)
      .frame(maxWidth: .infinity)
      .frame(height: 200.0)
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
      .onTapGesture {
        withAnimation {
          isOverlayShown.toggle()
        }
      }
      .overlay {
        if isOverlayShown {
          Rectangle()
            .stroke(.yellow)
            .offset(x: .zero, y: rect.height)
            .transition(.opacity.animation(.easeIn(duration: 0.15)))
        }
      }
  }
}

struct SUExpandableBlock_Preview: PreviewProvider {
  static var previews: some View {
    ZStack {
      SUColorStandartPalette
        .background
        .ignoresSafeArea()
      SUExpandableBlock()
        .background(.purple.opacity(0.1))
//        .cornerRadius(20.0)
    }
  }
}
