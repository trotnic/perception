//
//  ShelfScreen.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 21.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI
import SwiftUIRouter

struct ShelfScreen: View {

    @StateObject var viewModel: ShelfViewModel

    var body: some View {
        GeometryReader { _ in
            ZStack {
                ColorProvider.background
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    ZStack {
                        VStack {
                            SUButton(icon: "chevron.left") {
                                viewModel.backAction()
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
                            Text(viewModel.navigationTitle)
                                .font(.custom("Comfortaa", size: 20).weight(.bold))
                                .foregroundColor(ColorProvider.text)
                        }
                    }
                    .padding(.top, 16)
                    ScrollView {
                        VStack(spacing: 40) {
                            topTile
                            listItems
                        }
                        .padding(16)
                    }
                }
            }
        }
    }

    @ViewBuilder private var topTile: some View {
        ZStack {
            ColorProvider.tile
            VStack(alignment: .leading, spacing: 16) {
                Image(systemName: "pencil.and.outline")
                Text(viewModel.shelfTitle)
                    .font(.custom("Comfortaa", size: 18.0).weight(.bold))
                RoundedRectangle(cornerRadius: 1)
                    .fill(.white.opacity(0.2))
                    .frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                HStack(spacing: 12) {
                    Text("\(viewModel.documentsCount) documents")
                        .font(.custom("Comfortaa", size: 14).weight(.bold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke()
                                .fill(ColorProvider.redOutline)
                        }
                }
            }
            .foregroundColor(ColorProvider.text)
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .mask {
            RoundedRectangle(cornerRadius: 20)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke()
                .fill(.white.opacity(0.2))
        }
        .onAppear(perform: viewModel.loadShelfIfNeeded)
    }

    @ViewBuilder private var listItems: some View {
        LazyVGrid(columns: [
            .init(.flexible(minimum: .zero, maximum: .infinity))
        ], spacing: 24) {
            ForEach(viewModel.viewItems) { item in
                ListTile(viewItem: item) {
                    viewModel.selectItem(with: item.id)
                }
            }
        }
        .foregroundColor(ColorProvider.text)
    }
}

struct ShelfScreen_Previews: PreviewProvider {

    static let viewModel = ShelfViewModel(meta: .empty)

    static var previews: some View {
        ShelfScreen(viewModel: viewModel)
    }
}
