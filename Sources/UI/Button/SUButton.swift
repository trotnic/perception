//
//  SUButton.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 17.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

struct SUButton: View {

    @State private var isDetectingLongPress = false

    let icon: String
    let action: () -> Void

    // https://stackoverflow.com/a/65096819/13450895
    var body: some View {
        Image(systemName: icon)
            .foregroundColor(isDetectingLongPress ? ColorProvider.secondary1 : ColorProvider.text)
            .font(.system(size: 16.0).weight(.regular))
            .frame(width: 36.0, height: 36.0)
            .background {
                Circle()
                    .stroke(lineWidth: 2.0)
                    .fill(ColorProvider.secondary2)
                    .frame(width: isDetectingLongPress ? 32.0 : 36.0,
                           height: isDetectingLongPress ? 32.0 : 36.0)
            }
            .onTapGesture {
                action()
            }
//            .simultaneousGesture(
//                LongPressGesture(minimumDuration: .infinity)
//                    .onChanged({ isPressing in
//                        withAnimation(.easeInOut(duration: 0.25)) {
//                            isDetectingLongPress = isPressing
//                        }
//                    })
//                    .onEnded({ _ in
//                        action()
//                    })
//            )
//            .onLongPressGesture(
//                minimumDuration: .infinity,
//                perform: {
//                    action()
//                },
//                onPressingChanged: { isPressing in
//
//                })
//            .simultaneousGesture()
    }
}

struct SUButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorProvider.background
                .ignoresSafeArea()
            SUButton(icon: "ellipsis") {}
            .frame(width: 36.0, height: 36.0)
        }
    }
}
