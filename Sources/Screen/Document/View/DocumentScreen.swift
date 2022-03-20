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
                            .frame(width: 36.0, height: 36.0)
                    }
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    VStack(spacing: 2.0) {
                        if tileFrame.origin.y + 8.0 < navbarFrame.origin.y {
                            Text(documentViewModel.title)
                                .font(.custom("Comfortaa", size: 18.0).weight(.bold))
                                .foregroundColor(SUColorStandartPalette.text)
                        }
                    }
                    .animation(.easeInOut(duration: 0.12), value: tileFrame.origin.y + 8.0 < navbarFrame.origin.y)
                }
                .padding(.top, 16)
                .onTapGesture {
                    textCanvasFocus = false
                }
                GeometryReader { scrollProxy in
                    ScrollView {
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
                                    .preference(key: SUFrameKey.self, value: proxy.frame(in: .global))
                                    .onPreferenceChange(SUFrameKey.self) { tileFrame = $0 }
                            }
                        }
                        
                        SUTextCanvas(text: $documentViewModel.text)
                            .padding(.vertical, 16.0)
                            .frame(width: proxy.size.width - 40.0)
                            .focused($textCanvasFocus)
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
                            .preference(key: SUFrameKey.self, value: scrollProxy.frame(in: .global))
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
                                    .preference(key: SUFrameKey.self, value: proxy.frame(in: .global))
                                    .onPreferenceChange(SUFrameKey.self) { toolbarFrame = $0 }
                            }
                        }
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, 10.0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear(perform: documentViewModel.load)
    }
}

private extension DocumentScreen {

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
