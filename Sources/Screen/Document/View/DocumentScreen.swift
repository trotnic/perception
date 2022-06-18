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
import UniformTypeIdentifiers

#if os(macOS)
import AppKit
#endif

struct DocumentScreen {

  struct ImageIdentifiable: Identifiable {
    let id = UUID()
    let image: Image
  }

  enum InputItem {
    case emoji
    case title
  }

  @StateObject var documentViewModel: DocumentViewModel
  @StateObject var settingsViewModel: ToolbarSettingsViewModel

  @State private var isToolbarExpanded: Bool = false

  @FocusState private var focusNode: InputItem?

  @State private var tileFrame: CGRect = .zero
  @State private var toolbarFrame: CGRect = .zero

  @State private var isDeleteAlertPresented: Bool = false
  @State private var isImagePickerPresented: Bool = false
  @State private var isTextFromImagePickerPresented: Bool = false
  @State private var isDocumentScanPresented: Bool = false

  @State private var isToolbarShown = true

  @State private var detailImage: ImageIdentifiable?
  @State private var isTileHidden = true
}

extension DocumentScreen: View {

  var body: some View {
    NavigationView {
      GeometryReader { proxy in
        SUColorStandartPalette.background
          .edgesIgnoringSafeArea(.all)
        VStack(spacing: 8.0) {
          NavigationBar()
          ContentView()
        }
        .blur(radius: isToolbarExpanded ? 2.0 : 0.0)
        .overlay {
          if isToolbarShown {
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
                      .onPreferenceChange(SUFrameKey.self) { frame in
                        DispatchQueue.main.async {
                          toolbarFrame = frame
                        }
                      }
                  }
                }
                .opacity(focusNode == nil ? 1.0 : 0.0)
            }
            .frame(
              maxHeight: .infinity,
              alignment: .bottom
            )
            .padding(.bottom, 10.0)
          }
        }
        .frame(
          maxWidth: .infinity,
          maxHeight: .infinity
        )
      }
      .onAppear(perform: documentViewModel.start)
  #if os(iOS)
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
                  guard let data = image?.pngData() else { return }
                  documentViewModel.startTextFromImageRecognition(data: data)
                }
              }
            )
          )
        }
      )
      .fullScreenCover(
        isPresented: $isDocumentScanPresented,
        onDismiss: {},
        content: {
          SUDocumentScan { scans in
            scans
              .compactMap { $0.pngData() }
              .forEach(documentViewModel.insertImageAction(data:))
          }
        }
      )
      .fullScreenCover(
        item: $detailImage,
        onDismiss: {
          detailImage = nil
        },
        content: {
          SUImageContainer(image: $0.image)
        }
      )
      .navigationBarHidden(true)
  #endif
    }
    .alert("Are you sure you want to delete this workspace?", isPresented: $isDeleteAlertPresented) {
      Button("Cancel", role: .cancel) {
        isDeleteAlertPresented = false
      }
      Button("Delete", role: .destructive, action: documentViewModel.deleteAction)
    }
  }
}

private extension DocumentScreen {

  func NavigationBar() -> some View {
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
    }
    .overlay {
      GeometryReader { proxy in
        VStack(spacing: 2.0) {
          if isTileHidden {
            Text(documentViewModel.title)
              .font(.custom("Comfortaa", size: 18.0).weight(.bold))
              .foregroundColor(SUColorStandartPalette.text)
          }
        }
        .animation(
          .easeInOut(duration: 0.12),
          value: isTileHidden
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .onChange(of: tileFrame) { tileFrame in
          isTileHidden = tileFrame.origin.y + 8.0 < proxy.frame(in: .global).maxY
        }
      }
    }
    .padding(.top, 16)
  }

  func ContentView() -> some View {
    GeometryReader { scrollProxy in
      ScrollView {
        TopTile()
        VStack(spacing: 6.0) {
          DocumentBlocks(size: scrollProxy.size)
          AddTextBlockTile(
            size: scrollProxy.size,
            action: documentViewModel.pasteTextBlock
          )
//          .border(.red)
        }
        .frame(maxHeight: .infinity)
        Color.clear
          .padding(.bottom, toolbarFrame.height + 40.0)
      }
      .frame(maxHeight: .infinity)
      .foregroundColor(SUColorStandartPalette.text)
      .overlay {
        if isTileHidden {
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
  }

  func TopTile() -> some View {
    VStack {
      HStack {
        SUButtonEmoji(
          text: $documentViewModel.emoji,
          commit: {},
          onStart: {}
        )
          .frame(width: 28.0, height: 28.0)
          .focused($focusNode, equals: .emoji)
        Spacer()
      }
      TextField(
        String.empty,
        text: $documentViewModel.title
      )
        .textFieldStyle(PlainTextFieldStyle())
        .font(.custom("Comfortaa", size: 36.0).bold())
        .frame(maxWidth: .infinity, alignment: .leading)
        .focused($focusNode, equals: .title)
        .toolbar {
          ToolbarItemGroup(placement: .keyboard) {
            HStack {
              Spacer()
              Button {
                focusNode = nil
              } label: {
                Image(systemName: "keyboard.chevron.compact.down")
              }
            }
          }
        }
    }
    .padding(.vertical, 16.0)
    .padding(.horizontal, 16.0)
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
          .onPreferenceChange(SUFrameKey.self) { frame in
            if
              (tileFrame.minY < frame.minY && isTileHidden) ||
                (tileFrame.minY > frame.minY && !isTileHidden)
            {
              DispatchQueue.main.async {
                tileFrame = frame
              }
            }
          }
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
              set: { item.content = $0 }
            ),
            width: size.width - 40.0,
            onStart: {
              withAnimation(.easeInOut(duration: 0.52)) {
                isToolbarShown = false
              }
            },
            onFinish: {
              withAnimation(.easeInOut(duration: 0.26)) {
                isToolbarShown = true
              }
            },
            onCommit: {
              withAnimation(.easeInOut(duration: 0.26)) {
                isToolbarShown = true
              }
              item.deleteAction()
            }
          )
          .frame(width: size.width - 40.0)
//          .border(.orange)
        case .image:
          AsyncImage(
            url: URL(string: item.content)
          ) { image in
            image
              .resizable()
              .scaledToFill()
              .onTapGesture {
                detailImage = ImageIdentifiable(image: image)
              }
          } placeholder: {
            Color.purple.opacity(0.1)
          }
          .frame(
            width: size.width - 40.0,
            height: size.width - 40.0
          )
          .clipped()
          .cornerRadius(10.0)
          .contextMenu {
            Group {
              Button(role: .destructive) {
                item.deleteAction()
              } label: {
                Label("Delete", systemImage: "trash")
              }
            }
          }
      }
    }
    .animation(Animation.easeInOut(duration: 0.12))
  }
}

// MARK: - Toolbar

private extension DocumentScreen {

  func Toolbar() -> some View {
    SUToolbar(
      isExpanded: $isToolbarExpanded,
      defaultTwins: ToolbarDefaultTwins,
      leftItems: ToolbarLeftItems,
      rightItems: ToolbarRightItems
    )
  }

  func ToolbarDefaultTwins() -> [SUToolbar.Item.Twin] {
    [
      SUToolbar.Item.Twin(
        icon: "trash",
        title: "Delete document",
        type: .destructive,
        action: {
          isDeleteAlertPresented = true
        }
      )
    ]
  }

  func ToolbarLeftItems() -> [SUToolbar.Item] {
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
      ),
      SUToolbar.Item(
        icon: "magnifyingglass",
        twins: [
          SUToolbar.Item.Twin(
            icon: "magnifyingglass",
            title: "Search",
            type: .actionNext,
            action: { }
          )
        ]
      )
    ]
  }

  func ToolbarRightItems() -> [SUToolbar.Item] {
    [
      SUToolbar.Item(
        icon: "link.badge.plus",
        twins: [
          SUToolbar.Item.Twin(
            icon: "photo",
            title: "Photo",
            type: .action,
            action: {
#if os(iOS)
              isImagePickerPresented = true
#endif
#if os(macOS)
              let openPanel = NSOpenPanel()
              openPanel.prompt = "Select File"
              openPanel.allowsMultipleSelection = false
              openPanel.canChooseDirectories = false
              openPanel.canCreateDirectories = false
              openPanel.canChooseFiles = true
              openPanel.allowedContentTypes = [.image]
              openPanel.begin { (result) -> Void in
                if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                  let selectedPath = openPanel.url!.path
                  print(selectedPath)
                }
              }
#endif
            }
          ),
          SUToolbar.Item.Twin(
            icon: "text.magnifyingglass",
            title: "Text from a photo",
            type: .action,
            action: {
#if os(iOS)
              self.isTextFromImagePickerPresented = true
#endif
#if os(macOS)
              let openPanel = NSOpenPanel()
              openPanel.prompt = "Select File"
              openPanel.allowsMultipleSelection = false
              openPanel.canChooseDirectories = false
              openPanel.canCreateDirectories = false
              openPanel.canChooseFiles = true
              openPanel.allowedContentTypes = [.image]
              openPanel.begin { (result) -> Void in
                if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                  let selectedPath = openPanel.url!.path
                  print(selectedPath)
                }
              }
#endif
            }
          )
        ] + ToolbarPhoneSpecificTwins()
      )
    ]
  }

  func ToolbarPhoneSpecificTwins() -> [SUToolbar.Item.Twin] {
#if os(iOS)
    [
      SUToolbar.Item.Twin(
        icon: "doc.viewfinder",
        title: "Scan document",
        type: .action,
        action: {
          self.isDocumentScanPresented = true
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
#else
    []
#endif
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
      items: {
        [
          .init(
            id: "someid",
            type: .text,
            content: "Some text to check the behaviour",
            dateCreated: .now
          )
        ]
      }
    ),
    temporaryFileManager: SUManagerTemporaryFileMock(),
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
