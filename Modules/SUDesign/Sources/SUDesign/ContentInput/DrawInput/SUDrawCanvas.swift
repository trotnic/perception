//
//  SUDrawCanvas.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 17.04.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

#if os(iOS)
import Foundation
import SwiftUI
import PencilKit

struct SUDrawCanvasInternal: UIViewRepresentable {

  @Binding private var canvasView: PKCanvasView
  @Binding private var toolPickerIsActive: Bool

  private let onDone: () -> Void
  private let toolPicker = PKToolPicker()

  init(
    canvasView: Binding<PKCanvasView>,
    toolPickerIsActive: Binding<Bool>,
    onDone: @escaping () -> Void
  ) {
    
    _canvasView = canvasView
    _toolPickerIsActive = toolPickerIsActive
    self.onDone = onDone
  }

  func makeUIView(context: Context) -> PKCanvasView {
    canvasView.backgroundColor = .clear
    canvasView.isOpaque = true
    canvasView.delegate = context.coordinator
    toolPicker.setVisible(true, forFirstResponder: canvasView)
    toolPicker.addObserver(canvasView)

    canvasView.becomeFirstResponder()

    return canvasView
  }

  func updateUIView(
    _ uiView: PKCanvasView,
    context: Context
  ) {
    toolPicker.setVisible(toolPickerIsActive, forFirstResponder: uiView)
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(
      canvasView: $canvasView,
      toolPicker: toolPicker,
      onDone: onDone
    )
  }

  class Coordinator: NSObject, PKCanvasViewDelegate {
    private var canvasView: Binding<PKCanvasView>
    private let onDone: () -> Void
    private let toolPicker: PKToolPicker

    deinit {
      toolPicker.setVisible(false, forFirstResponder: canvasView.wrappedValue)
      toolPicker.removeObserver(canvasView.wrappedValue)
    }

    init(
      canvasView: Binding<PKCanvasView>,
      toolPicker: PKToolPicker,
      onDone: @escaping () -> Void
    ) {
      self.canvasView = canvasView
      self.onDone = onDone
      self.toolPicker = toolPicker
    }

    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
      if canvasView.drawing.bounds.isEmpty == false {
        onDone()
      }
    }
  }
}

public struct SUDrawCanvas {
  @Binding private var canvasView: PKCanvasView
  @Binding private var toolPickerIsActive: Bool

  public init(
    canvasView: Binding<PKCanvasView>,
    toolPickerIsActive: Binding<Bool>
  ) {
    _canvasView = canvasView
    _toolPickerIsActive = toolPickerIsActive
  }
}

extension SUDrawCanvas: View {
  public var body: some View {
    SUDrawCanvasInternal(
      canvasView: $canvasView,
      toolPickerIsActive: $toolPickerIsActive,
      onDone: {}
    )
  }
}
#endif
