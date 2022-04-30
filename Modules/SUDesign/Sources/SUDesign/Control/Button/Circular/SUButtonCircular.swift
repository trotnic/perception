//
//  SUButtonCircular.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 17.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

public struct SUButtonCircular {

  private let icon: String
  private let size: CGSize
  private let action: () -> Void

  public init(
    icon: String,
    size: CGSize = CGSize(
      width: 36.0,
      height: 36.0
    ),
    action: @escaping () -> Void
  ) {
    self.icon = icon
    self.size = size
    self.action = action
  }
}

extension SUButtonCircular: View {

  public var body: some View {
    Button(action: action) {
      Image(systemName: icon)
        .font(.system(size: 16.0).weight(.regular))
        .frame(width: size.width, height: size.height)
    }
    .buttonStyle(SUButtonCircularStyle())
    .frame(width: size.width, height: size.height)
  }
}

struct SUButton_Previews: PreviewProvider {

  static var previews: some View {
    ZStack {
      Color.black
        .ignoresSafeArea()
      SUButtonCircular(
        icon: "ellipsis",
        size: CGSize(width: 36.0, height: 36.0)
      ) {}
    }
  }
}
