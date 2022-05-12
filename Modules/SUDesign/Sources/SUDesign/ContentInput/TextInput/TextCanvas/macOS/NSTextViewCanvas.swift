//
//  NSTextViewCanvas.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 12.05.22.
//

#if os(macOS)
import AppKit
import SwiftUI

public extension String {
  func height(
    width: CGFloat,
    font: NSFont
  ) -> CGFloat {
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox = self.boundingRect(
      with: constraintRect,
      options: [.usesLineFragmentOrigin, .usesDeviceMetrics],
      attributes: [.font: font],
      context: nil
    )

    return ceil(boundingBox.height)
  }
}

// Wraps the NSTextView in a frame that can interact with SwiftUI
struct NSTextViewCanvas: View {
  private var placeholder: String
  @Binding private var text: String
  @Binding private var dynamicHeight: CGFloat // TODO: - Find better way to stop initial view bobble (gets bigger)
  @State private var textIsEmpty: Bool
  @State private var textViewInset: CGFloat = 9 // TODO: - Calculate insetad of magic number
  var nsFont: NSFont

  init(
    placeholder: String = "",
    dynamicHeight: Binding<CGFloat>,
    text: Binding<String>,
    nsFont: NSFont
  ) {
    self.placeholder = placeholder
    _dynamicHeight = dynamicHeight
    _text = text
    _textIsEmpty = State(wrappedValue: text.wrappedValue.isEmpty)
    self.nsFont = nsFont
  }

  var body: some View {
    ZStack {
      NSTextViewWrapper(
        text: $text,
        dynamicHeight: $dynamicHeight,
        textIsEmpty: $textIsEmpty,
        textViewInset: $textViewInset,
        nsFont: nsFont
      )
      .background(placeholderView, alignment: .topLeading)
      // Adaptive frame applied to this NSViewRepresentable
      .frame(minHeight: dynamicHeight, maxHeight: dynamicHeight)
    }
  }

  // Background placeholder text matched to default font provided to the NSViewRepresentable
  var placeholderView: some View {
    Text(placeholder)
    // Convert NSFont
      .font(.system(size: nsFont.pointSize))
      .opacity(textIsEmpty ? 0.3 : 0)
      .padding(.leading, textViewInset)
      .animation(.easeInOut(duration: 0.15), value: placeholder)
  }
}

// Creates the NSTextView
private struct NSTextViewWrapper: NSViewRepresentable {
  @Binding var text: String
  @Binding var dynamicHeight: CGFloat
  @Binding var textIsEmpty: Bool
  // Hoping to get this from NSTextView,
  // but haven't found the right parameter yet
  @Binding var textViewInset: CGFloat
  var nsFont: NSFont

  func makeCoordinator() -> Coordinator {
    Coordinator(
      text: $text,
      height: $dynamicHeight,
      textIsEmpty: $textIsEmpty,
      nsFont: nsFont
    )
  }

  func makeNSView(context: NSViewRepresentableContext<NSTextViewWrapper>) -> NSTextView {
    context.coordinator.textView
  }

  func updateNSView(
    _ textView: NSTextView,
    context: NSViewRepresentableContext<NSTextViewWrapper>
  ) {
    NSTextViewWrapper.recalculateHeight(view: textView, result: $dynamicHeight, nsFont: nsFont)
  }

  static func recalculateHeight(
    view: NSTextView,
    result: Binding<CGFloat>,
    nsFont: NSFont
  ) {
    // Uses visibleRect as view.sizeThatFits(CGSize())
    // is not exposed in AppKit, except on NSControls.
    let latestSize = view.visibleRect
    let latestHeight = view.string.height(width: 300.0, font: nsFont)
    if result.wrappedValue != latestSize.height &&
        // TODO: - The view initially renders slightly smaller than needed, then resizes.
        // I thought the statement below would prevent the @State dynamicHeight, which
        // sets itself AFTER this view renders, from causing it. Unfortunately that's not
        // the right cause of that redawing bug.
        latestSize.height > (nsFont.pointSize + 1) {
      DispatchQueue.main.async {
        result.wrappedValue = latestHeight
        print(#function, latestSize.height)
      }
    }
  }

  // Maintains the NSTextView's persistence despite redraws
  final class Coordinator: NSObject, NSTextViewDelegate, NSControlTextEditingDelegate {
    var textView: NSTextView
    @Binding var text: String
    @Binding var dynamicHeight: CGFloat
    @Binding var textIsEmpty: Bool
    var nsFont: NSFont

    init(
      text: Binding<String>,
      height: Binding<CGFloat>,
      textIsEmpty: Binding<Bool>,
      nsFont: NSFont
    ) {

      _text = text
      _dynamicHeight = height
      _textIsEmpty = textIsEmpty
      self.nsFont = nsFont

      textView = NSTextView(frame: .zero)
      textView.isEditable = true
      textView.isSelectable = true

      // Appearance

      textView.usesAdaptiveColorMappingForDarkAppearance = true
      textView.font = nsFont
      textView.textColor = NSColor.textColor
      textView.drawsBackground = false
      textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

      // Functionality (more available)
      textView.allowsUndo = true
      textView.isAutomaticLinkDetectionEnabled = true
      textView.displaysLinkToolTips = true
      textView.isAutomaticDataDetectionEnabled = true
      textView.isAutomaticTextReplacementEnabled = true
      textView.isAutomaticDashSubstitutionEnabled = true
      textView.isAutomaticSpellingCorrectionEnabled = true
      textView.isAutomaticQuoteSubstitutionEnabled = true
      textView.isAutomaticTextCompletionEnabled = true
      textView.isContinuousSpellCheckingEnabled = true

      super.init()
      // Load data from binding and set font
      textView.textStorage?.setAttributedString(NSAttributedString(string: text.wrappedValue))
      //        textView.textStorage?.setAttributedString(text.wrappedValue)
      textView.textStorage?.font = nsFont
      textView.delegate = self
    }

    func textDidChange(_ notification: Notification) {
      // Recalculate height after every input event
      NSTextViewWrapper.recalculateHeight(view: textView, result: $dynamicHeight, nsFont: nsFont)
      // If ever empty, trigger placeholder text visibility
      if let update = (notification.object as? NSTextView)?.string {
        textIsEmpty = update.isEmpty
      }
      $text.wrappedValue = textView.string
    }

    func textDidEndEditing(_ notification: Notification) {
      // Update binding only after editing ends; useful to gate NSManagedObjects
      $text.wrappedValue = textView.attributedString().string
    }
  }

}
#endif
