//
//  SUToolbar.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 21.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

public struct SUToolbar {

    private enum Constants {
        static let animationDuration = 0.24
    }

    public enum Row {
        case actionNext
        case action
    }

    // swiftlint:disable nesting
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
    // swiftlint:enable nesting

    @Namespace private var namespace
    @Namespace private var notchNamespace

    @State private var selectedTwins: [Item.Twin] = []
    @Binding private var isExpanded: Bool

    private let defaultTwins: [Item.Twin]
    private let leftItems: [Item]
    private let rightItems: [Item]

    public init(
        isExpanded: Binding<Bool>,
        defaultTwins: () -> [Item.Twin] = { [ ] },
        leftItems: () -> [Item] = { [] },
        rightItems: () -> [Item] = { [] }
    ) {
        _isExpanded = isExpanded
        self.defaultTwins = defaultTwins()
        self.leftItems = leftItems()
        self.rightItems = rightItems()
    }
}

extension SUToolbar: View {

    public var body: some View {
        VStack {
            if isExpanded {
                ExpandedBar()
                    .overlay {
                        HStack {
                            TopNotch()
                                .matchedGeometryEffect(id: "notch", in: notchNamespace)
                        }
                        .padding(.top, 16.0)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    }
            } else {
                UnexpandedBar()
                    .overlay {
                        HStack {
                            TopNotch()
                                .matchedGeometryEffect(id: "notch", in: notchNamespace)
                        }
                        .padding(.top, 16.0)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    }
            }
        }
        .onAppear {
            selectedTwins = defaultTwins
        }
    }
}

private extension SUToolbar {

    // swiftlint:disable identifier_name
    func TopNotch() -> some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(SUColorStandartPalette.secondary2)
            .frame(width: 40, height: 4)
    }

    func ExpandedBar() -> some View {
        ZStack {
            VStack(spacing: 16.0) {
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
            .padding(.top, 8.0)
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
                withAnimation(.easeInOut(duration: Constants.animationDuration)) {
                    isExpanded = false
                }
            }
            .padding(.horizontal, 12.0)
        }
    }

    func UnexpandedBar() -> some View {
        GeometryReader { proxy in
            HStack {
                HStack(spacing: 12.0) {
                    ForEach(leftItems) { item in
                        SUButtonCircular(icon: item.icon) {
                            selectedTwins = item.twins
                            withAnimation(.easeInOut(duration: Constants.animationDuration)) {
                                isExpanded = true
                            }
                        }
                        .frame(width: proxy.size.width * 0.128, height: proxy.size.width * 0.128)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: 12.0) {
                    ForEach(rightItems) { item in
                        SUButtonCircular(icon: item.icon) {
                            selectedTwins = item.twins
                            withAnimation(.easeInOut(duration: Constants.animationDuration)) {
                                isExpanded = true
                            }
                        }
                        .frame(width: proxy.size.width * 0.128, height: proxy.size.width * 0.128)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
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
                    .matchedGeometryEffect(id: "overlay", in: namespace, isSource: isExpanded)
            }
            .shadow(color: .black.opacity(0.18), radius: 6.0, x: 0.0, y: 4.0)
            .onTapGesture {
                guard !defaultTwins.isEmpty else { return }
                withAnimation(.easeInOut(duration: Constants.animationDuration)) {
                    selectedTwins = defaultTwins
                    isExpanded = true
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 80.0)
    }
}

// MARK: - Preview

struct SUToolbarContainerPreview: View {
    @State var isExpanded: Bool = false

    var body: some View {
        SUToolbar(
            isExpanded: $isExpanded,
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

struct SUToolbar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            SUColorStandartPalette.tile
                .ignoresSafeArea()
            VStack {
                Spacer()
                SUToolbarContainerPreview()
            }
        }
    }
}
