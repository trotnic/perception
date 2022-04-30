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
}

extension DrawingScreen: View {
  var body: some View {
    GeometryReader { proxy in
      SUColorStandartPalette.background
        .edgesIgnoringSafeArea(.all)
      VStack(spacing: 8.0) {
        ZStack {
          HStack(spacing: 14.0) {
            SUButtonCircular(
              icon: "chevron.left",
              action: viewModel.backAction
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
        GeometryReader { scrollProxy in
          SUDrawCanvas(
            canvasView: $canvasView,
            toolPickerIsActive: .constant(true)
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
