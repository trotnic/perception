//
//  SUListTile.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 18.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

public struct SUListTile {

    private let emoji: String
    private let title: String
    private let icon: String
    private let action: () -> Void

    public init(emoji: String,
                title: String,
                icon: String,
                action: @escaping () -> Void) {
        self.emoji = emoji
        self.title = title
        self.icon = icon
        self.action = action
    }
}

extension SUListTile: View {

    public var body: some View {
        Button {
            action()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(emoji)
                        Text(title)
                            .font(.custom("Comfortaa", size: 18).weight(.bold))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
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

private struct SUListTileButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct SUListTile_Previews: PreviewProvider {

    static var previews: some View {
        ZStack {
            SUColorStandartPalette.background
                .ignoresSafeArea()
            SUListTile(emoji: "🔥",
                       title: "Amazing workspace",
                       icon: "chevron.right") {
                
            }
        }
    }
}
