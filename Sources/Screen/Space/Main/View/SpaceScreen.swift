//
//  SpaceScreen.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 3.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI
import SwiftUIRouter

struct SpaceScreen {
    @StateObject var viewModel: SpaceViewModel
}

extension SpaceScreen: View {

    var body: some View {
        GeometryReader { _ in
            ZStack {
                ColorProvider.background
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    ZStack {
                        VStack {
                            SUButton(icon: "plus") {
                                viewModel.createAction()
                            }
                        }
                        .padding(.trailing, 16)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        VStack {
                            Text(viewModel.title)
                                .font(.custom("Comfortaa", size: 20).weight(.bold))
                                .foregroundColor(ColorProvider.text)
                        }
                    }
                    .padding(.top, 16)
                    ScrollView {
                        VStack(spacing: 40) {
                            listItems
                        }
                        .padding(16)
                    }
                }
            }
//            .overlay {
//                VStack {
//                    SUToolbar(
//                        unexpandedItems: {
//                            SUButton(icon: "gear") { print("Settings!") }
//                            Spacer()
//                        },
//                        expandedItems: [
//                            ("Create workspace", { viewModel.createAction() })
//                        ]
//                    )
//                }
//                .frame(maxHeight: .infinity, alignment: .bottom)
//                .ignoresSafeArea()
//                .offset(y: -10)
//            }
        }
        .onAppear(perform: viewModel.load)
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

struct HomeScreen_Previews: PreviewProvider {

    static let viewModel = SpaceViewModel()

    static var previews: some View {
        SpaceScreen(viewModel: viewModel)
            .previewDevice("iPhone 13 mini")
    }
}
