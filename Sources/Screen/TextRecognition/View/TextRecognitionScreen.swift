//
//  TextRecognitionScreen.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 17.04.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SUDesign
import SwiftUI
import SUFoundation

struct TextRecognitionScreen {
  @StateObject var viewModel: TextRecognitionScreenViewModel
}

extension TextRecognitionScreen: View {
  var body: some View {
    GeometryReader { proxy in
      SUColorStandartPalette.background
        .edgesIgnoringSafeArea(.all)
      VStack(spacing: 8.0) {
        ZStack {
          HStack(spacing: 24.0) {
            SUButtonCircular(
              icon: "chevron.left",
              size: CGSize(width: 20.0, height: 20.0),
              action: viewModel.backAction
            )
          }
          .padding(.leading, 16)
          .frame(
            maxWidth: .infinity,
            alignment: .leading
          )
          HStack(spacing: 28.0) {
            SUButtonCircular(
              icon: "checkmark",
              size: CGSize(width: 20.0, height: 20.0),
              action: viewModel.saveAction
            )
          }
          .padding(.trailing, 16)
          .frame(
            maxWidth: .infinity,
            alignment: .trailing
          )
        }
        .padding(.top, 16)
        GeometryReader { imageProxy in
          VStack(
            alignment: .center,
            spacing: 24.0
          ) {
            ImageTile(size: imageProxy.size)
            Text(viewModel.recognizedString)
              .frame(width: imageProxy.size.width)
              .font(.body)
              .foregroundColor(SUColorStandartPalette.text)
          }
          .padding(.top, 16.0)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16.0)
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
    .onAppear(perform: viewModel.loadAction)
    .onDisappear(perform: viewModel.cleanUpAction)
  }
}

extension TextRecognitionScreen {
  func ImageTile(size: CGSize) -> some View {
    ZStack {
      if
        let image = viewModel.image
      {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
          .overlay {
            GeometryReader { imageReader in
              Color.clear
                .preference(
                  key: SUFrameKey.self,
                  value: imageReader.frame(in: .local)
                )
                .onPreferenceChange(SUFrameKey.self) { viewModel.imageFrame = $0 }
            }
          }
          .overlay {
            Path { path in
              viewModel.recognizedBoxes
                .reversed()
                .forEach { path.addRect($0) }
            }
            .stroke(Color.yellow)
          }
          .frame(height: size.width)
          .frame(maxWidth: .infinity)
      }
    }
    .padding(8.0)
    .frame(
      width: size.width,
      height: size.width
    )
    .background {
      SUColorStandartPalette
        .tile
    }
    .cornerRadius(16.0)
  }

  
}

struct TextRecognitionScreen_Previews: PreviewProvider {
    static var previews: some View {
        TextRecognitionScreen(
          viewModel: TextRecognitionScreenViewModel(
            appState: SUAppStateProviderMock(),
            documentManager: SUManagerDocumentMock(),
            temporaryFileManager: SUManagerTemporaryFileMock(),
            documentMeta: .empty
          )
        )
    }
}
