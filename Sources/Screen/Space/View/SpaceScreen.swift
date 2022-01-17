//
//  SpaceScreen.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 3.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

let items: [SUWorkspace] = [
    .init(id: .init(), title: "The Amazing Cow-Man"),
    .init(id: .init(), title: "Cool books"),
    .init(id: .init(), title: "Extended reality"),
    .init(id: .init(), title: "Biology project"),
    .init(id: .init(), title: "Workspace #1")
]

struct SpaceScreen {
    @StateObject private var viewModel = SpaceViewModel()
    @State private var workspaceName: String = ""
}

extension SpaceScreen: View {

    var body: some View {
        GeometryReader { _ in
            ZStack {
                ColorProvider.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    listItems
                }
                .padding(.horizontal, 16)
            }
        }

    }

    @ViewBuilder private var listItems: some View {
        LazyVGrid(columns: [
            .init(.flexible(minimum: .zero, maximum: .infinity))
        ], spacing: 24) {
            ForEach(items) { item in
                ZStack {
                    ColorProvider.tileColor
                    HStack {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("🔥")
                                Text(item.title)
                                    .font(.custom("Comfortaa", size: 18).weight(.bold))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "person.2")
                                        .font(.system(size: 14).weight(.regular))
                                    Text("12 members")
                                        .font(.system(size: 14))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(ColorProvider.redOutlineColor)
                                        }
                                }
                                HStack {
                                    Image(systemName: "clock.arrow.circlepath")
                                        .font(.system(size: 14).weight(.regular))
                                    Text("10:21, December 10, 2021")
                                        .font(.system(size: 14))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(ColorProvider.redOutlineColor)
                                        }
                                }
                            }
                        }
                        .padding(16)
                        .frame(maxHeight: .infinity, alignment: .top)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 24).weight(.regular))
                    }
                    .padding(.trailing, 16)
                }
                .mask {
                    RoundedRectangle(cornerRadius: 20)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke()
                        .fill(Color.white.opacity(0.2))
                }
            }
        }
        .foregroundColor(ColorProvider.textColor)

    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        SpaceScreen()
            .previewDevice("iPhone 11 Pro")
    }
}
