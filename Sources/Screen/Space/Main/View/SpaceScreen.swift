//
//  SpaceScreen.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 3.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI
import SwiftUIRouter
import SUDesign

struct SpaceScreen {
    @StateObject var spaceViewModel: SpaceViewModel
    @StateObject var settingsViewModel: ToolbarSettingsViewModel

    @State private var isToolbarExpanded: Bool = false
}

extension SpaceScreen: View {

    var body: some View {
        GeometryReader { _ in
            ZStack {
                SUColorStandartPalette.background
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    ZStack {
                        VStack {
                            SUButtonCircular(icon: "plus") {
                                spaceViewModel.createAction()
                            }
                        }
                        .padding(.trailing, 16)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        VStack {
                            Text(spaceViewModel.title)
                                .font(.custom("Comfortaa", size: 20).weight(.bold))
                                .foregroundColor(SUColorStandartPalette.text)
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
            .overlay {
                VStack {
                    SUToolbar(isExpanded: $isToolbarExpanded, leftItems: [
                        .init(icon: "gear", twins: [
                            .init(icon: "person", title: "Account", type: .actionNext) {
                                settingsViewModel.accountAction()
                            }
                        ])
                    ])
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea()
                .offset(y: -10)
            }
        }
        .onAppear(perform: spaceViewModel.load)
    }

    @ViewBuilder private var listItems: some View {
        LazyVGrid(columns: [
            .init(.flexible(minimum: .zero, maximum: .infinity))
        ], spacing: 24) {
            ForEach(spaceViewModel.viewItems) { item in
                ListTile(viewItem: item) {
                    spaceViewModel.selectItem(with: item.id)
                }
            }
        }
        .foregroundColor(SUColorStandartPalette.text)
    }
}

//struct HomeScreen_Previews: PreviewProvider {
//
//    static let viewModel = SpaceViewModel(environment: .preview)
//    static let set
//
//    static var previews: some View {
//        SpaceScreen(spaceViewModel: viewModel)
//            .previewDevice("iPhone 13 mini")
//    }
//}
