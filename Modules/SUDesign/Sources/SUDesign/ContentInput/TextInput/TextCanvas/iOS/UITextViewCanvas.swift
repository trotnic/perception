//
//  UITextViewCanvas.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 12.05.22.
//

#if os(iOS)
import UIKit
import SwiftUI

//https://stackoverflow.com/a/58639072
//https://stackoverflow.com/a/20269793
struct UITextViewCanvas: UIViewRepresentable {
  @Binding var text: String
  @Binding var calculatedHeight: CGFloat
  var width: CGFloat

  var onFinish: () -> Void
  var onCommit: () -> Void

  func makeCoordinator() -> Coordinator {
    Coordinator(text: $text, height: $calculatedHeight, width: width)
  }

  func makeUIView(context: UIViewRepresentableContext<UITextViewCanvas>) -> UITextView {
    let textField = SULastCharTextView(
      frame: CGRect(
        origin: .zero,
        size: CGSize(
          width: width,
          height: calculatedHeight
        )
      )
    ) {
      onCommit()
    }
    textField.delegate = context.coordinator
    textField.textAlignment = .left

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
    textField.text = text

    textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    textField.setContentHuggingPriority(.required, for: .horizontal)

//    textField.layer.borderColor = UIColor.red.cgColor
//    textField.layer.borderWidth = 1.0

    let toolbar = UIToolbar()
    let closeButton = UIBarButtonItem(
      image: UIImage(systemName: "keyboard.chevron.compact.down"),
      callback: onFinish
    )
    toolbar.items = [
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      closeButton
    ]
    toolbar.sizeToFit()
    textField.inputAccessoryView = toolbar

    NSLayoutConstraint.activate([
      textField.widthAnchor.constraint(equalToConstant: width)
    ])
    return textField
  }

  func updateUIView(
    _ view: UITextView,
    context: UIViewRepresentableContext<UITextViewCanvas>
  ) {
    UITextViewCanvas.recalculateHeight(
      view: view,
      width: width,
      result: $calculatedHeight
    )
  }

  private static func recalculateHeight(
    view: UITextView,
    width: CGFloat,
    result: Binding<CGFloat>
  ) {
    let newHeight = view.text.height(width: width - 18.0, font: view.font!)
    if result.wrappedValue != newHeight {
      DispatchQueue.main.async {
        result.wrappedValue = newHeight + 14.0 // !! must be called asynchronously
        view.bounds.size = CGSize(
          width: width,
          height: newHeight + 14.0
        )
      }
    }
  }

  final class Coordinator: NSObject, UITextViewDelegate {
    @Binding private var text: String
    @Binding private var calculatedHeight: CGFloat

    private let width: CGFloat

    init(
      text: Binding<String>,
      height: Binding<CGFloat>,
      width: CGFloat
    ) {
      _text = text
      _calculatedHeight = height
      self.width = width
    }

    func textViewDidChange(_ uiView: UITextView) {
      text = uiView.text
      UITextViewCanvas.recalculateHeight(
        view: uiView,
        width: width,
        result: $calculatedHeight
      )
    }
  }
}
#endif
