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
}

extension DocumentScreen: View {

    var body: some View {
        GeometryReader { proxy in
            SUColorStandartPalette.background
                .edgesIgnoringSafeArea(.all)
            VStack {
                ZStack {
                    VStack {
                        SUButtonCircular(icon: "chevron.left", action: documentViewModel.backAction)
                            .frame(width: 36.0, height: 36.0)
                    }
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
//                    HStack(spacing: 16.0) {
//                        SUButtonCircular(icon: "trash") {
//                            documentViewModel.deleteAction()
//                        }
//                        .frame(width: 36.0, height: 36.0)
//                        SUButtonCircular(icon: "ellipsis") {}
//                            .frame(width: 36.0, height: 36.0)
//                    }
//                    .padding(.trailing, 16)
//                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.top, 16)
                ScrollView {
                    ZStack {
                        Text(documentViewModel.title)
                            .font(.system(size: 36.0, design: .rounded).bold())
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
            .overlay {
                HStack(alignment: .bottom) {
                    toolbar
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

    var toolbar: some View {
        SUToolbar(
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
        appState: SUAppStateProviderMock()
    )

    static var previews: some View {
        DocumentScreen(
            documentViewModel: documentViewModel,
            settingsViewModel: settingsViewModel
        )
            .previewDevice("iPhone 13 mini")
    }
}
