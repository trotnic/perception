//
//  SUNavigationBar.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 15.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI
import SUDesign

struct SUNavigationBar: View {

    let title: String

    var body: some View {
        ZStack {
            
            Color.clear
                .background(.ultraThinMaterial)
                .blur(radius: 1)
            Text(title)
                .font(.custom("Cofmortaa", size: 26.0).bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)

            VStack {
                SUButtonCircular(icon: "chevron.left") {}
            }
            .padding(.leading, 16)
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack {
                SUButtonCircular(icon: "ellipsis") {}
            }
            .padding(.trailing, 16)
            .frame(maxWidth: .infinity, alignment: .trailing)

        }
        .frame(height: 70)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

struct SUNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        SUNavigationBar(title: "Workspace")
    }
}
