//
//  ListTile.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 17.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

struct ListTile: View {
    let viewItem: ListTileViewItem

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(viewItem.iconText)
                    Text(viewItem.title)
                        .font(.custom("Comfortaa", size: 18).weight(.bold))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "person.2")
                            .font(.system(size: 14).weight(.regular))
                        Text(viewItem.membersTitle)
                            .font(.system(size: 14))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke()
                                    .fill(ColorProvider.redOutlineColor)
                            }
                    }
                    HStack {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 14).weight(.regular))
                        Text(viewItem.lastEditTitle)
                            .font(.system(size: 14))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke()
                                    .fill(ColorProvider.redOutlineColor)
                            }
                    }
                }
            }
            Image(systemName: "chevron.right")
                .font(.system(size: 24).weight(.regular))
        }
        .padding(16)
        .foregroundColor(.white)
        .background {
            ColorProvider.tileColor
        }
        .mask {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke()
                .fill(.white.opacity(0.08))
        }
    }
}

struct ListTile_Previews: PreviewProvider {
    static let viewItem: ListTileViewItem =
        .init(iconText: "🔥",
              title: "The Amazing Spider-Man",
              membersTitle: "12 members",
              lastEditTitle: "10:21, December 10, 2021")

    static var previews: some View {
        ZStack {
            ColorProvider.backgroundColor
                .ignoresSafeArea()
            ListTile(viewItem: viewItem)
                .padding(.horizontal, 20)
        }
    }
}
