//
//  WorkspaceScreen.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 13.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

struct WorkspaceScreen: View {

    @StateObject var viewModel = WorkspaceViewModel()

    var body: some View {
        GeometryReader { _ in
            ZStack {
                ColorProvider.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    ZStack {
                        VStack {
                            Circle()
                                .stroke(lineWidth: 2)
                                .fill(.gray)
                                .frame(width: 36, height: 36)
                                .overlay {
                                    Image(systemName: "ellipsis")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16).weight(.regular))
                                }
                        }
                        .padding(.trailing, 16)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        VStack {
                            Circle()
                                .stroke(lineWidth: 2)
                                .fill(.gray)
                                .frame(width: 36, height: 36)
                                .overlay {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16).weight(.regular))
                                }
                        }
                        .padding(.leading, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        VStack {
                            Text("Workspace")
                                .font(.custom("Comfortaa", size: 20).weight(.bold))
                                .foregroundColor(ColorProvider.textColor)
                        }
                    }
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
            ColorProvider.tileColor
            VStack(alignment: .leading, spacing: 16) {
                Image(systemName: "pencil.and.outline")
                Text("Extended reality")
                    .font(.custom("Comfortaa", size: 24).weight(.bold))
                RoundedRectangle(cornerRadius: 1)
                    .fill(.white.opacity(0.2))
                    .frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                HStack(spacing: 12) {
                    Text("3 members")
                        .font(.custom("Comfortaa", size: 14).weight(.bold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke()
                                .fill(ColorProvider.redOutlineColor)
                        }
                    Text("52 documents")
                        .font(.custom("Comfortaa", size: 14).weight(.bold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke()
                                .fill(ColorProvider.redOutlineColor)
                        }
                }
            }
            .foregroundColor(ColorProvider.textColor)
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

extension View {
    func debug() -> some View {
        dump(self)
        return self
    }
}

struct WorkspaceScreen_Previews: PreviewProvider {
    static var previews: some View {
        WorkspaceScreen()
            .previewDevice("iPhone 13 mini")
    }
}
