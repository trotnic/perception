//
//  SUSecureTextFieldCapsule.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 13.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

public struct SUSecureTextFieldCapsule {

    @Binding private var text: String

    private let placeholder: String

    public init(
        text: Binding<String>,
        placeholder: String
    ) {
        _text = text
        self.placeholder = placeholder
    }
}

extension SUSecureTextFieldCapsule: View {

    public var body: some View {
        SecureField("", text: _text)
            .placeholder(when: text.isEmpty) {
                Text(placeholder)
                    .foregroundColor(SUColorStandartPalette.secondary1)
            }
            .textFieldStyle(PlainTextFieldStyle())
            .padding(16.0)
            .background(SUColorStandartPalette.tile)
            .cornerRadius(10.0)
            .foregroundColor(SUColorStandartPalette.text)
    }
}

private struct SUSecureTextFieldCapsule_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            VStack(alignment: .center) {
                SUSecureTextFieldCapsule(
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
