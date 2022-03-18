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
}

extension DocumentScreen: View {

    var body: some View {
        GeometryReader { proxy in
            SUColorStandartPalette.background
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 16.0) {
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
                }
                .padding(.top, 16)
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
                    .frame(maxWidth: proxy.size.width - 32, maxHeight: .infinity)
                    .background(SUColorStandartPalette.tile)
                    .cornerRadius(20.0)

                    SUTextCanvas(text: $documentViewModel.text)
                        .padding(.vertical, 16.0)
                        .frame(width: proxy.size.width - 40.0)
                }
                .foregroundColor(SUColorStandartPalette.text)
            }
            .blur(radius: isToolbarExpanded ? 6.0 : 0.0)
            .overlay {
                HStack(alignment: .bottom) {
                    Toolbar()
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
