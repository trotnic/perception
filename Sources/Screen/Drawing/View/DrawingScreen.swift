//
//  DrawingScreen.swift
//  Perception-iOS
//
//  Created by Uladzislau Volchyk on 16.04.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

#if os(iOS)
import SwiftUI
import SUDesign
import PencilKit
import SUFoundation

struct DrawingScreen {

  @StateObject var viewModel: DrawingScreenViewModel
  @State private var canvasView = PKCanvasView()
  @State private var isAlertPresented = false
  @State private var isToolPickerActive = true
}

extension DrawingScreen: View {
  var body: some View {
    GeometryReader { proxy in
      SUColorStandartPalette.background
        .edgesIgnoringSafeArea(.all)
      VStack(spacing: 8.0) {
        NavigationBar()
        GeometryReader { scrollProxy in
          SUDrawCanvas(
            canvasView: $canvasView,
            toolPickerIsActive: $isToolPickerActive
          )
        }
        .overlay {
          VStack {
            Rectangle()
              .fill(SUColorStandartPalette.secondary3)
              .frame(height: 1.0)
              .frame(maxWidth: .infinity)
            Spacer()
          }
        }
      }
      .frame(
        maxWidth: .infinity,
        maxHeight: .infinity
      )
    }
    .alert("Are you sure you want to leave?", isPresented: $isAlertPresented) {
      Button("Leave", role: .destructive) {
        isToolPickerActive = false
        viewModel.backAction()
      }
      Button("Cancel", role: .cancel) {
        isAlertPresented = false
      }
    } message: {
      Text("Unsaved changes will be lost")
    }
  }
}

private extension DrawingScreen {
  func NavigationBar() -> some View {
    ZStack {
      HStack(spacing: 14.0) {
        SUButtonCircular(
          icon: "chevron.left",
          action: {
            if canvasView.drawing.strokes.isEmpty {
              isToolPickerActive = false
              viewModel.backAction()
            } else {
              isAlertPresented = true
            }
          }
        )
      }
      .padding(.leading, 16)
      .frame(
        maxWidth: .infinity,
        alignment: .leading
      )
      HStack(spacing: 14.0) {
        SUButtonCircular(
          icon: "checkmark",
          action: {
            Task {
              guard let data = canvasView.drawing.image(
                from: canvasView.drawing.bounds,
                scale: 2.0
              ).pngData() else {
                return
              }
              try await viewModel.saveDrawingAction(data: data)
            }
          }
        )
        SUButtonCircular(
          icon: "trash",
          action: {
            canvasView.drawing = PKDrawing()
          }
        )
        SUButtonCircular(
          icon: "arrow.uturn.left",
          action: {
            canvasView.undoManager?.undo()
          }
        )
        SUButtonCircular(
          icon: "arrow.uturn.right",
          action: {
            canvasView.undoManager?.redo()
          }
        )
      }
      .padding(.trailing, 16)
      .frame(
        maxWidth: .infinity,
        alignment: .trailing
      )
    }
    .padding(.top, 16)
  }
}

struct DrawingScreen_Previews: PreviewProvider {
  static var previews: some View {
    DrawingScreen(
      viewModel: DrawingScreenViewModel(
        appState: SUAppStateProviderMock(),
        documentManager: SUManagerDocumentMock(),
        documentMeta: .empty
      )
    )
  }
}

#endif
