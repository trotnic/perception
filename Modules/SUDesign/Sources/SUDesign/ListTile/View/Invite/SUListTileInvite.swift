//
//  SUListTileInvite.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 13.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

public struct SUListTileInvite {

    private let content: Content
    private let confirmAction: () -> Void
    private let rejectAction: () -> Void

    @State private var isDropdownVisible: Bool = false

    public init(
        content: Content,
        confirmAction: @escaping () -> Void,
        rejectAction: @escaping () -> Void
    ) {
        self.content = content
        self.confirmAction = confirmAction
        self.rejectAction = rejectAction
    }
}

extension SUListTileInvite: View {

    public var body: some View {
        Tile()
    }
}

private extension SUListTileInvite {

    //swiftlint:disable identifier_name
    func Tile() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    if !content.emoji.isEmpty {
                        Text(content.emoji)
                    }
                    Text(content.title)
                        .font(.custom("Comfortaa", size: 18).weight(.bold))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                if !content.badges.isEmpty {
                    VStack(spacing: 8.0) {
                        ForEach(content.badges) { badge in
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
            HStack {
                Button(action: rejectAction) {
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 28.0).weight(.regular))
                        .foregroundColor(.red)
                }
                Button(action: confirmAction) {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 28.0).weight(.regular))
                        .foregroundColor(.green)
                }
            }
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
}

public extension SUListTileInvite {

    struct Content {
        public let title: String
        public let emoji: String
        public let badges: [Badge]

        public init(
            title: String,
            emoji: String,
            badges: [Badge]
        ) {
            self.title = title
            self.emoji = emoji
            self.badges = badges
        }
    }

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

struct SUListTileInvite_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            SUColorStandartPalette
                .background
                .ignoresSafeArea()
            SUListTileInvite(
                content: SUListTileInvite.Content(
                    title: "Amazing workspace",
                    emoji: "🔥",
                    badges: [
                        SUListTileInvite.Badge(
                            title: "3 documents",
                            icon: "doc.on.doc",
                            color: .red
                        ),
                        SUListTileInvite.Badge(
                            title: "31 July, 2020",
                            icon: "clock.arrow.circlepath",
                            color: .orange
                        ),
                    ]
                ),
                confirmAction: {},
                rejectAction: {}
            )
        }
    }
}
