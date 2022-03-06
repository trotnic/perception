//
//  SUButtonStroke.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 5.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

public struct SUButtonStroke {

    private let text: String
    private let action: () -> Void

    public init(
        text: String,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.action = action
    }
}

extension SUButtonStroke: View {

    public var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 14.0))
                .foregroundColor(SUColorStandartPalette.text)
        }
        .buttonStyle(SUButtonStrokeStyle())
    }
}

struct SUButtonStroke_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            SUColorStandartPalette.background
                .ignoresSafeArea()
            SUButtonStroke(text: "Edit profile") {}
        }
    }
}
