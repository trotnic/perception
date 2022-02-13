//
//  ListTile.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 17.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI
import SUDesign

struct ListTile: View {
    @GestureState private var press = false
    let viewItem: ListTileViewItem
    let action: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(viewItem.iconText)
                    Text(viewItem.title)
                        .font(.custom("Comfortaa", size: 18).weight(.bold))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
//                VStack(alignment: .leading, spacing: 8) {
//                    HStack {
//                        Image(systemName: "person.2")
//                            .font(.system(size: 14).weight(.regular))
//                        Text(viewItem.membersTitle)
//                            .font(.system(size: 14))
//                            .padding(.horizontal, 10)
//                            .padding(.vertical, 5)
//                            .overlay {
//                                RoundedRectangle(cornerRadius: 20)
//                                    .stroke()
//                                    .fill(ColorProvider.redOutline)
//                            }
//                    }
//                    HStack {
//                        Image(systemName: "clock.arrow.circlepath")
//                            .font(.system(size: 14).weight(.regular))
//                        Text(viewItem.lastEditTitle)
//                            .font(.system(size: 14))
//                            .padding(.horizontal, 10)
//                            .padding(.vertical, 5)
//                            .overlay {
//                                RoundedRectangle(cornerRadius: 20)
//                                    .stroke()
//                                    .fill(ColorProvider.redOutline)
//                            }
//                    }
//                }
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
        .scaleEffect(press ? 0.96 : 1)
        .animation(.spring(response: 0.5, dampingFraction: 0.6), value: press)
        .onTapGesture {
            action()
        }
//        .delaysTouches(for: 0.05) {
//            action()
//        }
//        .gesture(
//            LongPressGesture(minimumDuration: .infinity)
//                .updating($press) { currentState, gestureState, transaction in
//                    gestureState = currentState
//                }
//                .onEnded { _ in
//                }
//        )
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
    static let viewItem: ListTileViewItem =
        .init(iconText: "🔥",
              title: "The Amazing Spider-Man"
//              membersTitle: "12 members",
//              lastEditTitle: "10:21, December 10, 2021"
        )

    static var previews: some View {
        ZStack {
            SUColorStandartPalette.background
                .ignoresSafeArea()
            ListTile(viewItem: viewItem) {}
                .padding(.horizontal, 20)
        }
    }
}
