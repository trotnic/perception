//
//  SpaceCreateScreen.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 13.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI
import SwiftUIRouter

struct SpaceCreateScreen: View {

    @StateObject private var viewModel = SpaceCreateViewModel()

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ColorProvider.background
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 16.0) {
                    ZStack {
                        VStack {
                            SUButton(icon: "chevron.left") {
                                viewModel.backAction()
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        VStack {
                            Text("Create workspace")
                                .font(.custom("Comfortaa", size: 20.0).weight(.bold))
                                .foregroundColor(ColorProvider.text)
                        }
                        VStack {
                            SUButton(icon: "plus") {
                                viewModel.createWorkspace()
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.top, 16.0)
                    .padding(.horizontal, 16.0)
                    topTile
                        .frame(maxWidth: proxy.size.width - 32.0)
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }

    @ViewBuilder private var topTile: some View {
        VStack(alignment: .leading, spacing: 16) {
            TextField("", text: $viewModel.workspaceName)
                .placeholder(when: viewModel.workspaceName.isEmpty) {
                    Text("Name workspace")
                        .foregroundColor(ColorProvider.secondary1)
                }
                
            RoundedRectangle(cornerRadius: 1)
                .fill(.white.opacity(0.2))
                .frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
        }
        .foregroundColor(ColorProvider.text)
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            ColorProvider.tile
        }
        .mask {
            RoundedRectangle(cornerRadius: 20)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke()
                .fill(.white.opacity(0.2))
        }
    }

}

struct SpaceCreateScreen_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorProvider.background
                .ignoresSafeArea()
            SpaceCreateScreen()
        }
        .previewDevice("iPhone 13 mini")
    }
}
