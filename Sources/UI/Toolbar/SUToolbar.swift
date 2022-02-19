////
////  SUToolbar.swift
////  Perception
////
////  Created by Uladzislau Volchyk on 21.01.22.
////  Copyright © 2022 Star Unicorn. All rights reserved.
////
//
//import SwiftUI
//import SUDesign
//
//struct SUToolbar: View {
//
//    enum Row {
//        case actionNext
//        case action
//    }
//
//    struct Item: Identifiable {
//        struct Twin: Identifiable {
//            let id = UUID()
//            let icon: String
//            let title: String
//            let type: Row
//            let action: () -> Void
//        }
//
//        let id = UUID()
//        let icon: String
//        let twins: [Twin]
//    }
//
//    @Namespace private var namespace
//
//    @State private var selectedTwins: [Item.Twin] = []
//    @Binding var isExpanded: Bool
//
//    private let defaultTwins: [Item.Twin]
//    private let leftItems: [Item]
//    private let rightItems: [Item]
//    private let middleItem: Item?
//
//    init(isExpanded: Binding<Bool>,
//         defaultTwins: [Item.Twin] = [],
//         leftItems: [Item] = [],
//         rightItems: [Item] = [],
//         middleItem: Item? = nil)
//    {
//        assert(leftItems.count < 3)
//        assert(rightItems.count < 3)
//
//        self._isExpanded = isExpanded
//        self.defaultTwins = defaultTwins
//        self.leftItems = leftItems
//        self.rightItems = rightItems
//        self.middleItem = middleItem
//
//        selectedTwins = defaultTwins
//    }
//
//    var body: some View {
//        if isExpanded {
//            VStack(spacing: 16.0) {
//                RoundedRectangle(cornerRadius: 20)
//                    .fill(SUColorStandartPalette.secondary2)
//                    .frame(width: 48, height: 4)
//                VStack {
//                    ForEach(selectedTwins) { twin in
//                        HStack {
//                            HStack(spacing: 12.0) {
//                                Image(systemName: twin.icon)
//                                    .font(.system(size: 24.0).weight(.regular))
//                                Text(twin.title)
//                                    .font(.system(size: 16.0).weight(.bold))
//                            }
//                            Spacer()
//                            switch twin.type {
//                            case .action:
//                                EmptyView()
//                            case .actionNext:
//                                Image(systemName: "chevron.right")
//                                    .font(.system(size: 24.0).weight(.regular))
//                            }
//                        }
//                        .foregroundColor(SUColorStandartPalette.text)
//                        .padding(.horizontal, 8.0)
//                        .padding(.vertical, 16.0)
//                        .onTapGesture(perform: twin.action)
//                    }
//                }
//                .zIndex(1)
//            }
//            .padding(16.0)
//            .background {
//                SUColorStandartPalette.background
//                    .matchedGeometryEffect(id: "background", in: namespace, isSource: isExpanded)
//            }
//            .mask {
//                RoundedRectangle(cornerRadius: 20.0, style: .continuous)
//                    .matchedGeometryEffect(id: "mask", in: namespace, isSource: isExpanded)
//            }
//            .overlay {
//                RoundedRectangle(cornerRadius: 20.0, style: .continuous)
//                    .stroke()
//                    .fill(.white.opacity(0.04))
//                    .matchedGeometryEffect(id: "overlay", in: namespace, isSource: isExpanded)
//            }
//            .shadow(color: .black.opacity(0.18), radius: 6.0, x: 0.0, y: 4.0)
//            .frame(maxWidth: 351.0)
//            .onTapGesture {
//                withAnimation {
//                    isExpanded = false
//                    selectedTwins = defaultTwins
//                }
//            }
//        } else {
//            ZStack {
//                HStack {
//                    HStack(spacing: 12.0) {
//                        ForEach(leftItems) { item in
//                            SUButtonCircular(icon: item.icon) {
//                                selectedTwins = item.twins
//                                withAnimation {
//                                    isExpanded = true
//                                }
//                            }
//                        }
//                        Spacer()
//                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    HStack {
//                        if let item = middleItem {
//                            SUButtonCircular(icon: item.icon) {
//                                selectedTwins = item.twins
//                                withAnimation {
//                                    isExpanded = true
//                                }
//                            }
//                        }
//                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    HStack(spacing: 12.0) {
//                        Spacer()
//                        ForEach(rightItems) { item in
//                            SUButtonCircular(icon: item.icon) {
//                                selectedTwins = item.twins
//                                withAnimation {
//                                    isExpanded = true
//                                }
//                            }
//                        }
//                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//            }
//            .padding(16.0)
//            .background {
//                SUColorStandartPalette.background
//                    .matchedGeometryEffect(id: "background", in: namespace, isSource: !isExpanded)
//            }
//            .mask {
//                RoundedRectangle(cornerRadius: 20.0, style: .continuous)
//                    .matchedGeometryEffect(id: "mask", in: namespace, isSource: !isExpanded)
//            }
//            .overlay {
//                RoundedRectangle(cornerRadius: 20.0, style: .continuous)
//                    .stroke()
//                    .fill(.white.opacity(0.04))
//                    .matchedGeometryEffect(id: "overlay", in: namespace, isSource: !isExpanded)
//            }
//            .shadow(color: .black.opacity(0.18), radius: 6.0, x: 0.0, y: 4.0)
//            .frame(maxWidth: 351.0, maxHeight: 80.0)
//            .onTapGesture {
//                guard !defaultTwins.isEmpty else { return }
//                withAnimation {
//                    isExpanded = true
//                }
//            }
//        }
//    }
//}
//
//struct SUToolbar_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack {
//            SUColorStandartPalette.background
//                .ignoresSafeArea()
//            VStack {
//                Spacer()
//                SUToolbar(isExpanded: .constant(false),
//                    defaultTwins: [
//                    SUToolbar.Item.Twin(icon: "doc", title: "Create document", type: .actionNext) {}
//                ], leftItems: [
//                    SUToolbar.Item(icon: "gear", twins: [
//                        SUToolbar.Item.Twin(icon: "doc", title: "Create document", type: .actionNext) {}
//                    ]),
//                    SUToolbar.Item(icon: "gear", twins: [
//                        SUToolbar.Item.Twin(icon: "doc", title: "Create document", type: .actionNext) {}
//                    ])
//                ], rightItems: [
//                    SUToolbar.Item(icon: "gear", twins: [
//                        SUToolbar.Item.Twin(icon: "doc", title: "Create document", type: .actionNext) {}
//                    ]),
//                    SUToolbar.Item(icon: "gear", twins: [
//                        SUToolbar.Item.Twin(icon: "doc", title: "Create document", type: .actionNext) {}
//                    ])
//                ], middleItem: SUToolbar.Item(icon: "gear", twins: [
//                    SUToolbar.Item.Twin(icon: "doc", title: "Create document", type: .actionNext) {},
//                    SUToolbar.Item.Twin(icon: "doc", title: "Create document", type: .actionNext) {},
//                    SUToolbar.Item.Twin(icon: "doc", title: "Create document", type: .actionNext) {},
//                    SUToolbar.Item.Twin(icon: "doc", title: "Create document", type: .actionNext) {}
//                ]))
//            }
//        }
//        .previewDevice("iPhone 11 Pro")
//    }
//}
