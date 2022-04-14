//
//  SUButtonCircular.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 17.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

public struct SUButtonCircular {

    private let icon: String
    private let action: () -> Void

    public init(
        icon: String,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.action = action
    }
}

extension SUButtonCircular: View {

    public var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 13.0).weight(.regular))
        }
        .buttonStyle(SUButtonCircularStyle())
    }
}

struct SUButton_Previews: PreviewProvider {

    static var previews: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            SUButtonCircular(icon: "ellipsis") {}
            .frame(width: 36.0, height: 36.0)
        }
    }
}
