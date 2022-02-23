//
//  SUListTile.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 18.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

public struct ListTile {

    let action: () -> Void
}

extension ListTile: View {

    public var body: some View {
        Button {
            action()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("🔥")
                        Text("Amazing workspace")
                            .font(.custom("Comfortaa", size: 18).weight(.bold))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                Image(systemName: "chevron.right")
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
        .buttonStyle(ListTileButtonStyle())
    }
}

private struct ListTileButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

extension View {
    func delaysTouches(for duration: TimeInterval = 0.25, onTap action: @escaping () -> Void = {}) -> some View {
        modifier(DelaysTouches(duration: duration, action: action))
    }
}

fileprivate struct DelaysTouches: ViewModifier {
    @State private var disabled = false
    @State private var touchDownDate: Date? = nil

    var duration: TimeInterval
    var action: () -> Void

    func body(content: Content) -> some View {
        Button(action: action) {
            content
        }
        .buttonStyle(DelaysTouchesButtonStyle(disabled: $disabled, duration: duration, touchDownDate: $touchDownDate))
        .disabled(disabled)
    }
}

fileprivate struct DelaysTouchesButtonStyle: ButtonStyle {
    @Binding var disabled: Bool
    var duration: TimeInterval
    @Binding var touchDownDate: Date?

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed, perform: handleIsPressed)
    }

    private func handleIsPressed(isPressed: Bool) {
        if isPressed {
            let date = Date()
            touchDownDate = date

            DispatchQueue.main.asyncAfter(deadline: .now() + max(duration, 0)) {
                if date == touchDownDate {
                    disabled = true

                    DispatchQueue.main.async {
                        disabled = false
                    }
                }
            }
        } else {
            touchDownDate = nil
            disabled = false
        }
    }
}

struct ListTile_Previews: PreviewProvider {
//    static let viewItem: ListTileViewItem =
//        .init(iconText: "🔥",
//              title: "The Amazing Spider-Man"
////              membersTitle: "12 members",
////              lastEditTitle: "10:21, December 10, 2021"
//        )

    static var previews: some View {
        ZStack {
            SUColorStandartPalette.background
                .ignoresSafeArea()
            ListTile() {}
                .padding(.horizontal, 20)
        }
    }
}
