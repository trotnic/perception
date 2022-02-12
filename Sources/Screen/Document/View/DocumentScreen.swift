//
//  DocumentScreen.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 29.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI
import SUDesign

struct DocumentScreen: View {

    @StateObject var viewModel: DocumentViewModel

    var body: some View {
        GeometryReader { proxy in
            ColorProvider.background
                .edgesIgnoringSafeArea(.all)
            VStack {
                ZStack {
                    VStack {
                        SUButtonCircular(icon: "chevron.left", action: viewModel.backAction)
                    }
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    VStack {
                        SUButtonCircular(icon: "ellipsis") {}
                    }
                    .padding(.trailing, 16)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    VStack {
//                        Text("LOLKEK")
//                            .font(.custom("Comfortaa", size: 20).weight(.bold))
//                            .foregroundColor(ColorProvider.text)
                    }
                }
                .padding(.top, 16)
                ScrollView {
                    ZStack {
                        Text("LOL")
//                        listItems
                    }
                    .padding(.vertical, 16.0)
                    .padding(.horizontal, 20.0)
                    .frame(maxWidth: proxy.size.width - 32)
                    .frame(height: 143.0)
                    .background(ColorProvider.tile)
                    .cornerRadius(20.0)
                    Text("LOLKEK CHEBUREK")
                }
                .foregroundColor(ColorProvider.text)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

struct DocumentScreen_Previews: PreviewProvider {
    static let viewModel = DocumentViewModel(meta: .empty)

    static var previews: some View {
        DocumentScreen(viewModel: viewModel)
            .previewDevice("iPhone 13 mini")
    }
}
