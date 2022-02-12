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
    static let indicatorWidth: CGFloat = 56
    static let indicatorHeight: CGFloat = 6
    static let snapRatio = 0.1
}

struct SUBottomSheet<Content: View>: View {
    @Binding var isOpen: Bool

    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: () -> Content

    @GestureState private var translation: CGFloat = 0

    init(isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.minHeight = maxHeight * 0.2
        self.maxHeight = maxHeight
        self.content = content
        self._isOpen = isOpen
    }

    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }

    private var indicator: some View {
        RoundedRectangle(cornerRadius: Constants.radius)
            .fill(.red)
            .frame(
                width: 72.0,
                height: 4.0
        )
    }

    @State private var frame: CGRect = .zero
    var body: some View {
        GeometryReader { proxy in
            Color.white
                .ignoresSafeArea()
                .frame(width: frame.width, height: frame.height)
            VStack(spacing: 8) {
                indicator
                content()
                    .padding()
            }
            .padding(.top, 12.0)
            .padding(.horizontal, 16.0)
            .frame(width: proxy.size.width, alignment: .top)
            .edgesIgnoringSafeArea([.bottom])
            .cornerRadius(20.0, corners: [.topLeft, .topRight])
//            .cornerRadius(20)
            .frame(height: proxy.size.height, alignment: .bottom)
            .frameGetter($frame)
//            .offset(y: max(self.offset + self.translation, 0))
//            .animation(.interactiveSpring(), value: isOpen)
//            .animation(.interactiveSpring(), value: translation)
//            .gesture(
//                DragGesture().updating($translation) { value, state, _ in
//                    state = value.translation.height
//                }.onEnded { value in
//                    let snapDistance = self.maxHeight * Constants.snapRatio
//                    guard abs(value.translation.height) > snapDistance else {
//                        return
//                    }
//                    isOpen = value.translation.height < 0
//                }
//            )
        }
    }
}

extension View {
    func frameGetter(_ frame: Binding<CGRect>) -> some View {
        modifier(FrameGetter(frame: frame))
    }
}

struct FrameGetter: ViewModifier {
    
    @Binding var frame: CGRect
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy -> AnyView in
                    let rect = proxy.frame(in: .global)
                    // This avoids an infinite layout loop
                    if rect.integral != self.frame.integral {
                        DispatchQueue.main.async {
                            self.frame = rect
                        }
                    }
                    return AnyView(EmptyView())
                })
    }
}

struct SUBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
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
}
