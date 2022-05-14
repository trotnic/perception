//
//  SUTextFieldCapsule.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 13.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI
#if os(macOS)
public typealias UIEdgeInsets = AppKit.NSEdgeInsets
#endif

public struct SUTextFieldCapsule {

  @Binding private var text: String
  private let placeholder: String
  private let paddings: UIEdgeInsets

  public init(
    text: Binding<String>,
    placeholder: String,
    paddings: UIEdgeInsets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
  ) {
    _text = text
    self.placeholder = placeholder
    self.paddings = paddings
  }
}

extension SUTextFieldCapsule: View {

  public var body: some View {
    TextField("", text: _text)
      .placeholder(when: text.isEmpty) {
        Text(placeholder)
          .font(.custom("Cofmortaa", size: 14.0))
          .foregroundColor(SUColorStandartPalette.secondary1)
      }
      .textFieldStyle(PlainTextFieldStyle())
      .padding(.leading, paddings.left)
      .padding(.top, paddings.top)
      .padding(.trailing, paddings.right)
      .padding(.bottom, paddings.bottom)
      .background(SUColorStandartPalette.tile)
      .cornerRadius(10.0)
      .foregroundColor(SUColorStandartPalette.text)
  }
}

private struct SUTextFieldCapsule_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            VStack(alignment: .center) {
                SUTextFieldCapsule(
                    text: .constant(""),
                    placeholder: "Enter your email"
                )
                    .frame(
                        width: proxy.size.width - 48.0,
                        height: 48.0
                    )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
