//
//  SUListTileMember.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 7.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

public struct SUListTileMember {

    private let content: Content
    private let action: () -> Void

    public init(
        content: Content,
        action: @escaping () -> Void
    ) {
        self.content = content
        self.action = action
    }
}

extension SUListTileMember: View {

    public var body: some View {
        Button(action: action) {
            HStack {
                VStack(
                    alignment: .leading,
                    spacing: 12
                ) {
                    HStack {
                        Circle()
                            .fill(.cyan)
                            .frame(width: 72.0, height: 72.0)
                        VStack(
                            alignment: .leading,
                            spacing: 8.0
                        ) {
                            Text(content.title)
                                .font(.system(size: 18.0, weight: .semibold))
                            ForEach(content.badges) { badge in
                                HStack {
                                    Image(systemName: badge.icon)
                                        .foregroundColor(.white)
                                    Text(badge.title)
                                        .padding(.vertical, 5.0)
                                        .padding(.horizontal, 10.0)
                                        .background(badge.color)
                                        .cornerRadius(20.0)
                                        .lineLimit(1)
                                }
                                .font(.system(size: 14.0, weight: .semibold))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                Image(systemName: "ellipsis")
                    .font(.system(size: 24).weight(.regular))
            }
            .padding(16)
            .foregroundColor(SUColorStandartPalette.text)
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

public extension SUListTileMember {

    struct Content {
        public let title: String
        public let badges: [Badge]

        public init(
            title: String,
            badges: [Badge]
        ) {
            self.title = title
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

struct SUListTileMember_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            SUColorStandartPalette.background
                .ignoresSafeArea()
            SUListTileMember(
                content: SUListTileMember.Content(
                    title: "Uladzislau Volchyk",
                    badges: [
                        SUListTileMember.Badge(
                            title: "Software Engineer",
                            icon: "person",
                            color: .cyan.opacity(0.4)
                        ),
                        SUListTileMember.Badge(
                            title: "editor",
                            icon: "gear",
                            color: .green.opacity(0.4)
                        )
                    ]
                ),
                action: {}
            )
        }
    }
}
