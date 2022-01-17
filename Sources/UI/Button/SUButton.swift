//
//  SUButton.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 17.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

struct SUButton: View {
    @GestureState var isDetectingLongPress = false
    let icon: String
    let action: () -> Void

    var tapGesture: some Gesture {
        LongPressGesture(minimumDuration: .infinity)
            .updating($isDetectingLongPress) { currentState, gestureState, transaction in
                gestureState = currentState
            }
            .onEnded { _ in
                action()
            }
    }

    var body: some View {
        Image(systemName: icon)
            .foregroundColor(isDetectingLongPress ? ColorProvider.secondary1 : ColorProvider.text)
            .font(.system(size: 16.0).weight(.regular))
            .background {
                Circle()
                    .stroke(lineWidth: 2.0)
                    .fill(ColorProvider.secondary2)
                    .frame(width: isDetectingLongPress ? 28.0 : 36.0,
                           height: isDetectingLongPress ? 28.0 : 36.0)
            }
            .animation(.easeInOut(duration: 0.25), value: isDetectingLongPress)
            .gesture(tapGesture)
    }
}

struct SUButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorProvider.background
                .ignoresSafeArea()
            SUButton(icon: "ellipsis") {}
        }
    }
}
