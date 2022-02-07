//
//  SUToolbar.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 21.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

struct SUToolbar: View {

    @State private var selectedTwins: [Item.Twin] = []
//    enum Alignment {
//        case left
//        case right
//        case middle
//    }

    enum Row {
        case actionNext
        case action
    }

    struct Item: Identifiable {
        struct Twin: Identifiable {
            let id = UUID()
            let icon: String
            let title: String
            let type: Row
            let action: () -> Void
        }

        let id = UUID()
        let icon: String
        let twins: [Twin]
    }

    @Namespace private var namespace
    @State private var isExpanded = false

    private let defaultTwins: [Item.Twin]
    private let leftItems: [Item]
    private let rightItems: [Item]
    private let middleItem: Item?

    init(defaultTwins: [Item.Twin] = [],
         leftItems: [Item] = [],
         rightItems: [Item] = [],
         middleItem: Item? = nil)
    {
        assert(leftItems.count < 3)
        assert(rightItems.count < 3)

        self.defaultTwins = defaultTwins
        self.leftItems = leftItems
        self.rightItems = rightItems
        self.middleItem = middleItem
    }

    var body: some View {
        if isExpanded {
            VStack(spacing: 16.0) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(ColorProvider.secondary2)
                    .frame(width: 48, height: 4)
                VStack {
                    ForEach(selectedTwins) { twin in
                        HStack {
                            HStack(spacing: 12.0) {
                                Image(systemName: twin.icon)
                                    .font(.system(size: 24.0).weight(.regular))
                                Text(twin.title)
                                    .font(.system(size: 16.0).weight(.bold))
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 24.0).weight(.regular))
                        }
                        .foregroundColor(ColorProvider.text)
                        .padding(.horizontal, 8.0)
                        .padding(.vertical, 16.0)
                        .onTapGesture(perform: twin.action)
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
                    HStack(spacing: 12.0) {
                        ForEach(leftItems) { item in
                            SUButton(icon: item.icon) {
                                selectedTwins = item.twins
                                withAnimation {
                                    isExpanded = true
                                }
                            }
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    HStack {
                        if let item = middleItem {
                            SUButton(icon: item.icon) {
                                selectedTwins = item.twins
                                withAnimation {
                                    isExpanded = true
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    HStack(spacing: 12.0) {
                        Spacer()
                        ForEach(rightItems) { item in
                            SUButton(icon: item.icon) {
                                selectedTwins = item.twins
                                withAnimation {
                                    isExpanded = true
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
            .frame(maxWidth: 351.0, maxHeight: 80.0)
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
                SUToolbar(defaultTwins: [
                    SUToolbar.Item.Twin(icon: "doc", title: "Create document", type: .actionNext) {}
                ], leftItems: [
                    SUToolbar.Item(icon: "gear", twins: [
                        SUToolbar.Item.Twin(icon: "doc", title: "Create document", type: .actionNext) {}
                    ]),
                    SUToolbar.Item(icon: "gear", twins: [
                        SUToolbar.Item.Twin(icon: "doc", title: "Create document", type: .actionNext) {}
                    ])
                ], rightItems: [
                    SUToolbar.Item(icon: "gear", twins: [
                        SUToolbar.Item.Twin(icon: "doc", title: "Create document", type: .actionNext) {}
                    ]),
                    SUToolbar.Item(icon: "gear", twins: [
                        SUToolbar.Item.Twin(icon: "doc", title: "Create document", type: .actionNext) {}
                    ])
                ], middleItem: SUToolbar.Item(icon: "gear", twins: [
                    SUToolbar.Item.Twin(icon: "doc", title: "Create document", type: .actionNext) {},
                    SUToolbar.Item.Twin(icon: "doc", title: "Create document", type: .actionNext) {},
                    SUToolbar.Item.Twin(icon: "doc", title: "Create document", type: .actionNext) {},
                    SUToolbar.Item.Twin(icon: "doc", title: "Create document", type: .actionNext) {}
                ]))
            }
        }
        .previewDevice("iPhone 11 Pro")
    }
}
