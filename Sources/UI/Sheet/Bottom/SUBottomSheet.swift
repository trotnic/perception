//
//  SUBottomSheet.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 15.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

private enum Constants {
    static let radius: CGFloat = 20
    static let indicatorWidth: CGFloat = 60
    static let indicatorHeight: CGFloat = 6
    static let snapRatio = 0.1
}


struct SUBottomSheet<Content: View>: View {
    @Binding var isOpen: Bool

    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content

    @GestureState private var translation: CGFloat = 0

    init(isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.minHeight = maxHeight * 0.2
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
    }

    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }

    private var indicator: some View {
        RoundedRectangle(cornerRadius: Constants.radius)
            .fill(.red)
            .frame(
                width: Constants.indicatorWidth,
                height: Constants.indicatorHeight
        )
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 8) {
                indicator.padding()
                content
                    .padding()
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(.white)
            .cornerRadius(Constants.radius)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring(), value: isOpen)
            .animation(.interactiveSpring(), value: translation)
            .gesture(
                DragGesture().updating($translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * Constants.snapRatio
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    isOpen = value.translation.height < 0
                }
            )
        }
    }
}

struct SUBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        SUBottomSheet(isOpen: .constant(true), maxHeight: 400) {
            VStack {
                ForEach(0..<4) { _ in
                    Text("One")
                        .frame(maxWidth: .infinity, minHeight: 40)
                        .background {
                            Color.red
                        }
                        .cornerRadius(10)
                        .padding(5)
                }
            }
        }
    }
}
