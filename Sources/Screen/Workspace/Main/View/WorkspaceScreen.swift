//
//  WorkspaceScreen.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 13.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI
import SwiftUIRouter

struct WorkspaceScreen: View {

    @StateObject var viewModel: WorkspaceViewModel

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
                            SUButton(icon: "plus") {
                                viewModel.createAction()
                            }
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
                Text(viewModel.workspaceTitle)
                    .font(.custom("Comfortaa", size: 18.0).weight(.bold))
                RoundedRectangle(cornerRadius: 1)
                    .fill(.white.opacity(0.2))
                    .frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                HStack(spacing: 12) {
                    Text("\(viewModel.membersCount) members")
                        .font(.custom("Comfortaa", size: 14).weight(.bold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke()
                                .fill(ColorProvider.redOutline)
                        }
                        
//                    Text("52 documents")
//                        .font(.custom("Comfortaa", size: 14).weight(.bold))
//                        .padding(.horizontal, 10)
//                        .padding(.vertical, 5)
//                        .overlay {
//                            RoundedRectangle(cornerRadius: 20)
//                                .stroke()
//                                .fill(ColorProvider.redOutline)
//                        }
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

extension View {
    func debug() -> some View {
        dump(self)
        return self
    }
}

struct WorkspaceScreen_Previews: PreviewProvider {

    static let viewModel = WorkspaceViewModel(meta: .empty)

    static var previews: some View {
        WorkspaceScreen(viewModel: viewModel)
            .previewDevice("iPhone 13 mini")
    }
}
