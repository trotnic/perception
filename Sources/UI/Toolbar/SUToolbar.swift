//
//  SUToolbar.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 21.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

struct SUToolbar<Unexpanded: View>: View {
    @Namespace private var namespace
    @State private var isExpanded = false
    @ViewBuilder var unexpandedItems: Unexpanded
    var expandedItems: [(String, () -> Void)]

    var body: some View {
        if isExpanded {
            VStack(spacing: 16.0) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(ColorProvider.secondary2)
                    .frame(width: 48, height: 4)
                VStack {
                    ForEach(expandedItems, id: \.self.0) { item in
                        HStack {
                            HStack(spacing: 12.0) {
                                Image(systemName: "plus.circle")
                                    .font(.system(size: 24.0).weight(.regular))
                                Text(item.0)
                                    .font(.system(size: 16.0).weight(.bold))
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 24.0).weight(.regular))
                        }
                        .foregroundColor(ColorProvider.text)
                        .padding(.horizontal, 8.0)
                        .padding(.vertical, 16.0)
                        .onTapGesture(perform: item.1)
                    }
                }
                .zIndex(1)
            }
            .padding(16.0)
            .background {
                ColorProvider.background
                    .matchedGeometryEffect(id: "background", in: namespace, isSource: isExpanded)
            }
            .mask {
                RoundedRectangle(cornerRadius: 20.0, style: .continuous)
                    .matchedGeometryEffect(id: "mask", in: namespace, isSource: isExpanded)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 20.0, style: .continuous)
                    .stroke()
                    .fill(.white.opacity(0.04))
                    .matchedGeometryEffect(id: "overlay", in: namespace, isSource: isExpanded)
            }
            .shadow(color: .black.opacity(0.18), radius: 6.0, x: 0.0, y: 4.0)
            .frame(maxWidth: 351.0)
            .onTapGesture {
                withAnimation {
                    isExpanded = false
                }
            }
        } else {
            ZStack {
                HStack {
                    unexpandedItems
                }
                .transition(.slide)
                .frame(maxWidth: .infinity)
            }
            .padding(16.0)
            .background {
                ColorProvider.background
                    .matchedGeometryEffect(id: "background", in: namespace, isSource: !isExpanded)
            }
            .mask {
                RoundedRectangle(cornerRadius: 20.0, style: .continuous)
                    .matchedGeometryEffect(id: "mask", in: namespace, isSource: !isExpanded)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 20.0, style: .continuous)
                    .stroke()
                    .fill(.white.opacity(0.04))
                    .matchedGeometryEffect(id: "overlay", in: namespace, isSource: !isExpanded)
            }
            .shadow(color: .black.opacity(0.18), radius: 6.0, x: 0.0, y: 4.0)
            .frame(maxWidth: 351.0)
            .onTapGesture {
                withAnimation {
                    isExpanded = true
                }
            }
        }
    }
}

struct SUToolbar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorProvider.background
                .ignoresSafeArea()
            VStack {
                Spacer()
                SUToolbar(
                    unexpandedItems: {
                        SUButton(icon: "gear") {}
                        Spacer()
                    },
                    expandedItems: [
                        ("Create workspace", {})
                    ]
                )
            }
        }
        .previewDevice("iPhone 11 Pro")
    }
}
