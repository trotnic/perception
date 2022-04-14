//
//  NavigationCheck.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 9.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

struct NavigationCheck: View {
    @State private var showActionSheet = false

    var body: some View {
        VStack {
            Text("Change photo")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.262745098, green: 0.0862745098, blue: 0.8588235294, alpha: 1)), Color(#colorLiteral(red: 0.5647058824, green: 0.462745098, blue: 0.9058823529, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(16)
                    .foregroundColor(.white)
        }
        .padding(.horizontal, 20)
        .onTapGesture {
            showActionSheet = true
        }
        #if os(iOS)
        .actionSheet(isPresented: $showActionSheet, content: {
            ActionSheet(title: Text("Choose a new photo"),
                        message: Text("Pick a photo that you like"),
                        buttons: [
                            .default(Text("Pick from library")) {
                                print("Tapped on pick from library")
                            },
                            .default(Text("Take a photo")) {
                                print("Tapped on take a photo")
                            },
                            .cancel()
                        ])
        })
        #endif
    }
}

struct NavigationCheck_Previews: PreviewProvider {
    static var previews: some View {
        NavigationCheck()
            .previewDevice("iPhone 13 mini")
    }
}
