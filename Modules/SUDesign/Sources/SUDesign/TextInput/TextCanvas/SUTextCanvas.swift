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

    @Binding var content: String

    public init(text: Binding<String>) {
        _content = text
    }
}

extension SUTextCanvas: UIViewRepresentable {

    public func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 42)
        return textView
    }

    public func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = content
    }
}
