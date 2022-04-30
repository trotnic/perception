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
    textField.text = text

    textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    textField.setContentHuggingPriority(.required, for: .horizontal)
    return textField
  }

  func updateUIView(_ view: UITextView, context: UIViewRepresentableContext<UITextViewWrapper>) {
    UITextViewWrapper.recalculateHeight(view: view, result: $calculatedHeight)
  }

  private static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
    guard let window = view.window else { return }
    let newSize = view.sizeThatFits(
      CGSize(
        width: window.bounds.width,
        height: CGFloat.greatestFiniteMagnitude
      )
    )
    if result.wrappedValue != newSize.height {
      DispatchQueue.main.async {
        result.wrappedValue = newSize.height // !! must be called asynchronously
        view.bounds.size = newSize
      }
    }
  }

  final class Coordinator: NSObject, UITextViewDelegate {
    @Binding private var text: String
    @Binding private var calculatedHeight: CGFloat

    init(
      text: Binding<String>,
      height: Binding<CGFloat>
    ) {
      _text = text
      _calculatedHeight = height
    }

    func textViewDidChange(_ uiView: UITextView) {
      self.text = uiView.text
      UITextViewWrapper.recalculateHeight(view: uiView, result: $calculatedHeight)
    }
  }
}

#endif

public struct SUTextCanvas {
  @Binding private var text: String
  @State private var dynamicHeight: CGFloat = 44.0

  public init(
    text: Binding<String>
  ) {
    _text = text
  }
}

extension SUTextCanvas: View {

  public var body: some View {
#if os(iOS)
    UITextViewWrapper(text: $text, calculatedHeight: $dynamicHeight)
      .frame(minHeight: dynamicHeight)
#elseif os(macOS)
    NSTextViewWrapper(text: $text, calculatedHeight: $dynamicHeight)
      .frame(minHeight: dynamicHeight, maxHeight: dynamicHeight)
#endif
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

#if os(macOS)

import AppKit

private struct NSTextViewWrapper: NSViewRepresentable {
  @Binding var text: String
  @Binding var calculatedHeight: CGFloat

  func makeCoordinator() -> Coordinator {
    Coordinator(text: $text, height: $calculatedHeight)
  }

  func makeNSView(context: NSViewRepresentableContext<NSTextViewWrapper>) -> NSTextView {
    let textField = NSTextView()
    textField.delegate = context.coordinator

    textField.isEditable = true
    textField.font = NSFont.preferredFont(forTextStyle: .body)
    textField.isSelectable = true
    textField.drawsBackground = false
    textField.allowsUndo = true

//    textField.textContainerInset = .zero
//    textField.textContainer.lineFragmentPadding = .zero
//    textField.textContainerInset = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
//    textField.keyboardType = .twitter
//
//    textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    return textField
  }

  func updateNSView(_ nsView: NSTextView, context: NSViewRepresentableContext<NSTextViewWrapper>) {
    if nsView.string != text {
      nsView.string = text
    }
  }

  private static func recalculateHeight(view: NSView, result: Binding<CGFloat>) {
//    view.size
//    let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
//    if result.wrappedValue != newSize.height {
//      DispatchQueue.main.async {
//        result.wrappedValue = newSize.height // !! must be called asynchronously
//      }
//    }
  }

  final class Coordinator: NSObject, NSTextViewDelegate {
    @Binding private var text: String
    @Binding private var calculatedHeight: CGFloat

    init(
      text: Binding<String>,
      height: Binding<CGFloat>
    ) {
      _text = text
      _calculatedHeight = height
    }

    func textDidChange(_ notification: Notification) {
      guard
        notification.name == NSText.didChangeNotification,
        let textView = (notification.object as? NSTextView),
        let latestText = textView.textStorage
      else { return }
      text = latestText.string
      // NSTextViewWrapper.recalculateHeight(view: textView, result: calculatedHeight)
    }

    func textView(_ textView: NSTextView, shouldChangeTextIn: NSRange, replacementString: String?) -> Bool {
      if replacementString == "\n" {
        textView.resignFirstResponder()
        //                onDone()
        return false
      }
      return true
    }

//    func textViewDidChange(_ uiView: UITextView) {
//      self.text = uiView.text
//      UITextViewWrapper.recalculateHeight(view: uiView, result: $calculatedHeight)
//    }
  }
}
#endif
