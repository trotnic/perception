//
//  SUImageContainer.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 13.05.22.
//

import SwiftUI

public struct SUImageContainer {
  private let image: Image

  @Environment(\.dismiss) private var dismiss

  public init(image: Image) {
    self.image = image
  }
}

extension SUImageContainer: View {
  public var body: some View {
    image
      .resizable()
      .scaledToFit()
      .gesture(
        DragGesture().onEnded { value in
          if value.location.y - value.startLocation.y > 150 {
            dismiss()
          }
        }
      )
  }
}

// MARK: - Preview

struct SUImageContainer_Previews: PreviewProvider {
    static var previews: some View {
      SUImageContainer(image: Image(systemName: "checkmark"))
    }
}
