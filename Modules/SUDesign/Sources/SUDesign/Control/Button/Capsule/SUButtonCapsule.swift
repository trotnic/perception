//
//  SUButtonCapsule.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 12.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

public struct SUButtonCapsule {

    @Binding private var isActive: Bool

    private let title: String
    private let size: CGSize
    private let action: () -> Void

    public init(
        isActive: Binding<Bool>,
        title: String,
        size: CGSize,
        action: @escaping () -> Void
    ) {
        _isActive = isActive
        self.title = title
        self.size = size
        self.action = action
    }
}

extension SUButtonCapsule: View {

    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Cofmortaa", size: 20.0).weight(.medium))
        }
        .buttonStyle(
            SUButtonCapsuleStyle(
                isActive: isActive,
                size: size
            )
        )
        .disabled(!isActive)
    }
}

private struct SUButtonCapsule_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            VStack(alignment: .center) {
                SUButtonCapsule(
                    isActive: .constant(true),
                    title: "Click Me!",
                    size: CGSize(
                        width: proxy.size.width - 48.0,
                        height: 56.0
                    )
                ) {
                }
            }
            .frame(width: proxy.size.width)
        }
    }
}
