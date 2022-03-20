//
//  SUListTileWork.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 18.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

public struct SUListTileWork {

    private let emoji: String
    private let title: String
    private let icon: String
    private let badges: [Badge]
    private let action: () -> Void

    public init(
        emoji: String,
        title: String,
        icon: String,
        badges: [Badge],
        action: @escaping () -> Void
    ) {
        self.emoji = emoji
        self.title = title
        self.icon = icon
        self.badges = badges
        self.action = action
    }
}

extension SUListTileWork: View {

    public var body: some View {
        Button {
            action()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        if !emoji.isEmpty {
                            Text(emoji)
                        }
                        Text(title)
                            .font(.custom("Comfortaa", size: 18).weight(.bold))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    if !badges.isEmpty {
                        VStack(spacing: 8.0) {
                            ForEach(badges) { badge in
                                HStack(spacing: 8) {
                                    Image(systemName: badge.icon)
                                        .frame(width: 24.0, height: 24.0)
                                    Text(badge.title)
                                        .font(.custom("Cofmortaa", size: 14.0))
                                        .padding(.vertical, 5.0)
                                        .padding(.horizontal, 10.0)
                                        .background(badge.color.opacity(0.2))
                                        .cornerRadius(20.0)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
                Image(systemName: icon)
                    .font(.system(size: 24).weight(.regular))
            }
            .padding(16)
            .foregroundColor(.white)
            .background {
                SUColorStandartPalette.tile
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
        .buttonStyle(SUListTileButtonStyle())
    }
}

public extension SUListTileWork {

    struct Badge: Identifiable {
        public let id = UUID()
        public let title: String
        public let icon: String
        public let color: Color

        public init(
            title: String,
            icon: String,
            color: Color
        ) {
            self.title = title
            self.icon = icon
            self.color = color
        }
    }
}

// MARK: - Preview

struct SUListTile_Previews: PreviewProvider {

    static var previews: some View {
        ZStack {
            SUColorStandartPalette.background
                .ignoresSafeArea()
            SUListTileWork(
                emoji: "🔥",
                title: "Amazing workspace",
                icon: "chevron.right",
                badges: [
                    SUListTileWork.Badge(
                        title: "3 documents",
                        icon: "doc.on.doc",
                        color: .red
                    ),
                    SUListTileWork.Badge(
                        title: "31 July, 2020",
                        icon: "clock.arrow.circlepath",
                        color: .orange
                    ),
                ]
            ) {}
        }
    }
}
