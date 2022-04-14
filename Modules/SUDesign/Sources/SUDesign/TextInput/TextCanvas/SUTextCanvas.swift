//
//  SUTextCanvas.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 19.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import SwiftUI

#if os(iOS)
//https://stackoverflow.com/a/58639072
//https://stackoverflow.com/a/20269793
private struct UITextViewWrapper: UIViewRepresentable {

    @Binding var text: String
    @Binding var calculatedHeight: CGFloat

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, height: $calculatedHeight)
    }

    func makeUIView(context: UIViewRepresentableContext<UITextViewWrapper>) -> UITextView {
        let textField = UITextView()
        textField.delegate = context.coordinator
        textField.translatesAutoresizingMaskIntoConstraints = false

        textField.isEditable = true
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.isSelectable = true
        textField.isUserInteractionEnabled = true
        textField.isScrollEnabled = false
        textField.backgroundColor = .clear
        textField.textColor = .white

        textField.textContainerInset = .zero
        textField.textContainer.lineFragmentPadding = .zero
        textField.textContainerInset = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
        textField.keyboardType = .twitter

        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewWrapper>) {
        if uiView.text != text {
            uiView.text = text
        }
//        if uiView.window != nil, !uiView.isFirstResponder {
//            uiView.becomeFirstResponder()
//        }
        UITextViewWrapper.recalculateHeight(view: uiView, result: $calculatedHeight)
    }

    private static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if result.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                result.wrappedValue = newSize.height // !! must be called asynchronously
            }
        }
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        @Binding var calculatedHeight: CGFloat

        init(text: Binding<String>, height: Binding<CGFloat>) {
            _text = text
            _calculatedHeight = height
        }

        func textViewDidChange(_ uiView: UITextView) {
            self.text = uiView.text
            UITextViewWrapper.recalculateHeight(view: uiView, result: $calculatedHeight)
        }
    }

}

public struct SUTextCanvas {

    @Binding private var text: String
    @State private var dynamicHeight: CGFloat = 44.0

    public init(text: Binding<String>) {
        _text = text
    }
}

extension SUTextCanvas: View {

    public var body: some View {
        UITextViewWrapper(text: $text, calculatedHeight: $dynamicHeight)
            .frame(minHeight: dynamicHeight, maxHeight: dynamicHeight)
    }
}

struct SUTextCanvasPreviews: PreviewProvider {
    static var previews: some View {
        ZStack {
            SUColorStandartPalette.background
                .ignoresSafeArea()
            SUTextCanvas(text: .constant("Some text to check"))
                .background(.red)
                .frame(width: .infinity, height: 40)
        }
    }
}

#endif
