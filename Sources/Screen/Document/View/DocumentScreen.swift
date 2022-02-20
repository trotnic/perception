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

    @StateObject var viewModel: DocumentViewModel
}

extension DocumentScreen: View {

    var body: some View {
        GeometryReader { proxy in
            SUColorStandartPalette.background
                .edgesIgnoringSafeArea(.all)
            VStack {
                ZStack {
                    VStack {
                        SUButtonCircular(icon: "chevron.left", action: viewModel.backAction)
                            .frame(width: 36.0, height: 36.0)
                    }
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    VStack {
                        SUButtonCircular(icon: "ellipsis") {}
                            .frame(width: 36.0, height: 36.0)
                    }
                    .padding(.trailing, 16)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.top, 16)
                ScrollView {
                    ZStack {
                        Text(viewModel.title)
                            .font(.system(size: 36.0, design: .rounded).bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical, 16.0)
                    .padding(.horizontal, 24.0)
                    .frame(maxWidth: proxy.size.width - 32)
                    .background(SUColorStandartPalette.tile)
                    .cornerRadius(20.0)

                    SUTextCanvas(text: $viewModel.text)
                        .padding()
                }
                .foregroundColor(SUColorStandartPalette.text)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear(perform: viewModel.load)
    }
}

struct DocumentScreen_Previews: PreviewProvider {
    static let viewModel = DocumentViewModel(
        appState: SUAppStateProviderMock(),
        documentManager: SUManagerDocumentMock(),
        documentMeta: .empty
    )

    static var previews: some View {
        DocumentScreen(viewModel: viewModel)
            .previewDevice("iPhone 13 mini")
    }
}
