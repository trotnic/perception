//
//  DocumentScreen.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 29.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI
import SUDesign
import SUFoundation

struct DocumentScreen {

  @StateObject var documentViewModel: DocumentViewModel
  @StateObject var settingsViewModel: ToolbarSettingsViewModel

  @State private var isToolbarExpanded: Bool = false
  @FocusState private var textCanvasFocus

  @State private var navbarFrame: CGRect = .zero
  @State private var tileFrame: CGRect = .zero
  @State private var toolbarFrame: CGRect = .zero
  @State private var isImagePickerPresented: Bool = false
  @State private var isTextFromImagePickerPresented: Bool = false
}

extension DocumentScreen: View {

  var body: some View {
    GeometryReader { proxy in
      SUColorStandartPalette.background
        .edgesIgnoringSafeArea(.all)
      VStack(spacing: 8.0) {
        ZStack {
          VStack {
            SUButtonCircular(
              icon: "chevron.left",
              action: documentViewModel.backAction
            )
          }
          .padding(.leading, 16)
          .frame(
            maxWidth: .infinity,
            alignment: .leading
          )
          VStack(spacing: 2.0) {
            if tileFrame.origin.y + 8.0 < navbarFrame.origin.y {
              Text(documentViewModel.title)
                .font(.custom("Comfortaa", size: 18.0).weight(.bold))
                .foregroundColor(SUColorStandartPalette.text)
            }
          }
          .animation(
            .easeInOut(duration: 0.12),
            value: tileFrame.origin.y + 8.0 < navbarFrame.origin.y
          )
        }
        .padding(.top, 16)
        .onTapGesture {
          textCanvasFocus = false
        }
        GeometryReader { scrollProxy in
          ScrollView {
            TopTile()
            VStack(spacing: 12.0) {
              DocumentBlocks(size: scrollProxy.size)
            }
            .frame(maxHeight: .infinity)
            Color.clear
              .padding(.bottom, toolbarFrame.height)
          }
          .foregroundColor(SUColorStandartPalette.text)
          .overlay {
            VStack {
              if tileFrame.origin.y + 8.0 < navbarFrame.origin.y {
                VStack {
                  Rectangle()
                    .fill(SUColorStandartPalette.secondary3)
                    .frame(height: 1.0)
                    .frame(maxWidth: .infinity)
                  Spacer()
                }
              }
            }
          }
          .overlay {
            Color.clear
              .preference(
                key: SUFrameKey.self,
                value: scrollProxy.frame(in: .global)
              )
              .onPreferenceChange(SUFrameKey.self) { navbarFrame = $0 }
          }
          .onTapGesture {
            withAnimation {
              isToolbarExpanded = false
            }
          }
        }
      }
      .blur(radius: isToolbarExpanded ? 2.0 : 0.0)
      .overlay {
        HStack(alignment: .bottom) {
          Toolbar()
            .background {
              GeometryReader { proxy in
                SUColorStandartPalette.background
                  .frame(height: proxy.size.height * 2.0)
                  .offset(y: -12.0)
                  .blur(radius: 6.0)
                  .preference(
                    key: SUFrameKey.self,
                    value: proxy.frame(in: .global)
                  )
                  .onPreferenceChange(SUFrameKey.self) { toolbarFrame = $0 }
              }
            }
        }
        .frame(
          maxHeight: .infinity,
          alignment: .bottom
        )
        .padding(.bottom, 10.0)
      }
      .frame(
        maxWidth: .infinity,
        maxHeight: .infinity
      )
    }
    .onAppear(perform: documentViewModel.load)
    .sheet(
      isPresented: $isImagePickerPresented,
      onDismiss: {},
      content: {
        SUImagePicker(
          image: .init(
            get: {
              nil
            },
            set: { image in
              Task {
                let data = image?.pngData()
                await MainActor.run {
                  documentViewModel.insertImageAction(data: data)
                }
              }
            }
          )
        )
      }
    )
    .sheet(
      isPresented: $isTextFromImagePickerPresented,
      onDismiss: {},
      content: {
        SUImagePicker(
          image: .init(
            get: {
              nil
            },
            set: { image in
              Task {
                guard let cgImage = image?.cgImage else { return }
                await MainActor.run {
                  documentViewModel.insertTextFromImageAction(cgImage: cgImage)
                }
              }
            }
          )
        )
      }
    )
  }
}

private extension DocumentScreen {

  func TopTile() -> some View {
    VStack {
      HStack {
        SUButtonEmoji(
          text: $documentViewModel.emoji,
          commit: {}
        )
          .frame(width: 28.0, height: 28.0)
        Spacer()
      }
      TextField(String.empty, text: $documentViewModel.title)
        .textFieldStyle(PlainTextFieldStyle())
        .font(.custom("Comfortaa", size: 36.0).bold())
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(.vertical, 16.0)
    .padding(.horizontal, 24.0)
    .background(SUColorStandartPalette.tile)
    .cornerRadius(20.0)
    .padding(.horizontal, 16.0)
    .padding(.top, 8.0)
    .background {
      GeometryReader { proxy in
        Color.clear
          .preference(
            key: SUFrameKey.self,
            value: proxy.frame(in: .global)
          )
          .onPreferenceChange(SUFrameKey.self) { tileFrame = $0 }
      }
    }
  }

  func DocumentBlocks(size: CGSize) -> some View {
    ForEach(documentViewModel.items) { item in
      switch item.type {
        case .text:
          SUTextCanvas(
            text: Binding<String>(
              get: { item.content },
              set: item.action
            )
          )
            .padding(.vertical, 16.0)
            .frame(width: size.width - 40.0)
            .focused($textCanvasFocus)
            .onTapGesture {
              textCanvasFocus = true
            }
            .background {
              Color.red.opacity(0.15)
            }
        case .image:
          AsyncImage(url: URL(string: item.content)) { image in
              image
              .resizable()
              .scaledToFit()
//              .frame(maxWidth: size.width)
          } placeholder: {
            Color.purple.opacity(0.1)
          }
            .frame(
              width: size.width - 40.0,
              height: size.width - 64.0
            )
            .clipped()
            .cornerRadius(10.0)
      }
    }
  }

  func Toolbar() -> some View {
    SUToolbar(
      isExpanded: $isToolbarExpanded,
      defaultTwins: {
        [
          SUToolbar.Item.Twin(
            icon: "trash",
            title: "Delete document",
            type: .action,
            action: documentViewModel.deleteAction
          )
        ]
      },
      leftItems: {
        [
          SUToolbar.Item(
            icon: "gear",
            twins: [
              SUToolbar.Item.Twin(
                icon: "person",
                title: "Account",
                type: .actionNext,
                action: settingsViewModel.accountAction
              )
            ]
          )
        ]
      },
      rightItems: {
        [
          SUToolbar.Item(
            icon: "link.badge.plus",
            twins: [
              SUToolbar.Item.Twin(
                icon: "photo",
                title: "Photo",
                type: .action,
                action: {
                  self.isImagePickerPresented = true
                }
              ),
              SUToolbar.Item.Twin(
                icon: "text.magnifyingglass",
                title: "Text from a photo",
                type: .action,
                action: {
                  self.isTextFromImagePickerPresented = true
                }
              ),
              SUToolbar.Item.Twin(
                icon: "paintbrush",
                title: "Drawing",
                type: .action,
                action: {
                  documentViewModel.drawingAction()
                }
              )
            ]
          )
        ]
      }
    )
  }
}

// MARK: - Preview

struct DocumentScreen_Previews: PreviewProvider {
  static let documentViewModel = DocumentViewModel(
    appState: SUAppStateProviderMock(),
    documentManager: SUManagerDocumentMock(
      meta: {
        .empty
      },
      title: {
        "Document #1"
      },
      text: {
        "Some text"
      }
    ),
    documentMeta: .empty
  )

  static let settingsViewModel = ToolbarSettingsViewModel(
    appState: SUAppStateProviderMock(),
    sessionManager: SUManagerUserPrimeMock()
  )

  static var previews: some View {
    DocumentScreen(
      documentViewModel: documentViewModel,
      settingsViewModel: settingsViewModel
    )
      .previewDevice("iPhone 13 mini")
  }
}
