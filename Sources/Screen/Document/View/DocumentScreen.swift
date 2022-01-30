//
//  DocumentScreen.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 29.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

struct DocumentScreen: View {

    @StateObject var viewModel: DocumentViewModel

    var body: some View {
        ZStack {
            ColorProvider.background
                .edgesIgnoringSafeArea(.all)
            VStack {
                ZStack {
                    VStack {
                        SUButton(icon: "chevron.left") {
//                            viewModel.backAction()
                        }
                    }
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    VStack {
                        SUButton(icon: "ellipsis") {}
                    }
                    .padding(.trailing, 16)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    VStack {
//                        Text(viewModel.navigationTitle)
//                            .font(.custom("Comfortaa", size: 20).weight(.bold))
//                            .foregroundColor(ColorProvider.text)
                    }
                }
                .padding(.top, 16)
                ScrollView {
                    VStack(spacing: 40) {
//                        topTile
//                        listItems
                    }
                    .padding(16)
                }
            }
        }
    }
}

struct DocumentScreen_Previews: PreviewProvider {
    static let viewModel = DocumentViewModel(meta: .empty)

    static var previews: some View {
        DocumentScreen(viewModel: viewModel)
    }
}
