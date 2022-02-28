//
//  SUToolbar.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 21.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

public struct SUToolbar {

    public enum Row {
        case actionNext
        case action
    }

    public struct Item: Identifiable {
        public struct Twin: Identifiable {
            public let id = UUID()
            public let icon: String
            public let title: String
            public let type: Row
            public let action: () -> Void

            public init(
                icon: String,
                title: String,
                type: Row,
                action: @escaping () -> Void
            ) {
                self.icon = icon
                self.title = title
                self.type = type
                self.action = action
            }
        }

        public let id = UUID()
        public let icon: String
        public let twins: [Twin]

        public init(
            icon: String,
            twins: [Twin]
        ) {
            self.icon = icon
            self.twins = twins
        }
    }

    @Namespace private var namespace

    @State private var selectedTwins: [Item.Twin] = []
    @State private var isExpanded: Bool = false

    private let defaultTwins: [Item.Twin]
    private let leftItems: [Item]
    private let rightItems: [Item]

    public init(
        defaultTwins: () -> [Item.Twin] = { [ ] },
        leftItems: () -> [Item] = { [] },
        rightItems: () -> [Item] = { [] }
    ) {
        self.defaultTwins = defaultTwins()
        self.leftItems = leftItems()
        self.rightItems = rightItems()
    }
}

extension SUToolbar: View {

    public var body: some View {
        Group {
            if isExpanded {
                expandedBar
            } else {
                unexpandedBar
            }
        }
        .onAppear {
            selectedTwins = defaultTwins
        }
    }
}

private extension SUToolbar {

    var topNotch: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(SUColorStandartPalette.secondary2)
            .frame(width: 40, height: 4)
    }

    var expandedBar: some View {
        VStack {
            VStack(spacing: 16.0) {
                topNotch
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
                            switch twin.type {
                            case .action:
                                EmptyView()
                            case .actionNext:
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 24.0).weight(.regular))
                            }
                        }
                        .foregroundColor(SUColorStandartPalette.text)
                        .padding(.horizontal, 8.0)
                        .padding(.vertical, 16.0)
                        .onTapGesture(perform: twin.action)
                    }
                }
            }
            .padding(16.0)
            .frame(maxWidth: .infinity)
            .background {
                SUColorStandartPalette.background
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
            .onTapGesture {
                withAnimation {
                    isExpanded = false
                }
            }
            .padding(.horizontal, 12.0)
        }
    }

    var unexpandedBar: some View {
        GeometryReader { proxy in
            VStack {
                VStack {
                    HStack {
                        HStack(spacing: 12.0) {
                            ForEach(leftItems) { item in
                                SUButtonCircular(icon: item.icon) {
                                    selectedTwins = item.twins
                                    withAnimation {
                                        isExpanded = true
                                    }
                                }
                                .frame(width: proxy.size.width * 0.128, height: proxy.size.width * 0.128)
                            }
                            Spacer()
                        }
                        VStack {
                            topNotch
                            Spacer()
                        }
                        HStack(spacing: 12.0) {
                            Spacer()
                            ForEach(rightItems) { item in
                                SUButtonCircular(icon: item.icon) {
                                    selectedTwins = item.twins
                                    withAnimation {
                                        isExpanded = true
                                    }
                                }
                                .frame(width: proxy.size.width * 0.128, height: proxy.size.width * 0.128)
                            }
                        }
                    }
                }
                .padding(16.0)
                .frame(width: proxy.size.width - 24.0)
                .background {
                    SUColorStandartPalette.background
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
                .onTapGesture {
                    guard !defaultTwins.isEmpty else { return }
                    withAnimation {
                        selectedTwins = defaultTwins
                        isExpanded = true
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 80.0)
    }
}

// MARK: - Preview

struct SUToolbar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            SUColorStandartPalette.tile
                .ignoresSafeArea()
            VStack {
                Spacer()
                SUToolbar(
                    defaultTwins: {
                        [
                            SUToolbar.Item.Twin(icon: "doc", title: "Create document", type: .actionNext) {},
                            SUToolbar.Item.Twin(icon: "doc", title: "Create document", type: .actionNext) {},
                            SUToolbar.Item.Twin(icon: "doc", title: "Create document", type: .actionNext) {}
                        ]
                    },
                    leftItems: {
                        [
                            SUToolbar.Item(icon: "gear", twins: [
                                SUToolbar.Item.Twin(icon: "doc", title: "Create document", type: .actionNext) {}
                            ]),
                            SUToolbar.Item(icon: "gear", twins: [
                                SUToolbar.Item.Twin(icon: "doc", title: "Create document", type: .actionNext) {}
                            ])
                        ]
                    },
                    rightItems: {
                        [
                            SUToolbar.Item(icon: "gear", twins: [
                                SUToolbar.Item.Twin(icon: "doc", title: "Create document", type: .actionNext) {}
                            ]),
                            SUToolbar.Item(icon: "gear", twins: [
                                SUToolbar.Item.Twin(icon: "doc", title: "Create document", type: .actionNext) {}
                            ])
                        ]
                    }
                )
            }
        }
    }
}