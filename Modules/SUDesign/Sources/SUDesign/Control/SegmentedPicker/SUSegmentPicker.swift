//
//  SUSegmentPicker.swift
//  
//
//  Created by Uladzislau Volchyk on 6.03.22.
//

import SwiftUI

public struct SUSegmentPicker {

    @Binding private var selectedIndex: Int
    @State private var selectedFrame: CGRect = .zero

    private let segments: [String]

    public init(
        selectedIndex: Binding<Int>,
        segments: [String]
    ) {
        _selectedIndex = selectedIndex
        self.segments = segments
    }
}

extension SUSegmentPicker: View {

    public var body: some View {
        ZStack(alignment: .centerBottom) {

            RoundedRectangle(cornerRadius: 20.0)
                .fill(SUColorStandartPalette.tint)
                .alignmentGuide(.centerHorizontal, computeValue: { $0[HorizontalAlignment.center] })
                .frame(width: selectedFrame.width, height: selectedFrame.height)
//                .animation(Animation.easeIn, value: selectedFrame != .zero ? selectedFrame.width : CGFloat(selectedIndex))

            HStack {
                ForEach(segments.indices, id: \.self) { index in
                    Group {
                        if index == selectedIndex {
                            Text(segments[index])
                                .alignmentGuide(.centerHorizontal, computeValue: { $0[HorizontalAlignment.center] })
                                .padding(.vertical, Constants.verticalPadding)
                                .padding(.horizontal, Constants.horizontalPadding)
                                .background(
                                    GeometryReader {
                                        Color.clear
                                            .preference(
                                                key: RectPreferenceKey.self,
                                                value: $0.frame(in: .global)
                                            )
                                            .onPreferenceChange(RectPreferenceKey.self) { rect in
                                                if selectedFrame != .zero {
                                                    withAnimation {
                                                        selectedFrame = rect
                                                    }
                                                } else {
                                                    selectedFrame = rect
                                                }
                                            }
                                    }
                                )
                        } else {
                            Text(segments[index])
                                .onTapGesture {
                                    withAnimation {
                                        selectedIndex = index
                                    }
                                }
                                .padding(.vertical, Constants.verticalPadding)
                                .padding(.horizontal, Constants.horizontalPadding)
                        }
                    }
                }
            }
            .foregroundColor(SUColorStandartPalette.text)
        }
    }
}

private extension SUSegmentPicker {

    enum Constants {
        static let verticalPadding: CGFloat = 8.0
        static let horizontalPadding: CGFloat = 12.0
    }
}

struct RectPreferenceKey: PreferenceKey {

    static var defaultValue = CGRect.zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

// MARK: - Preview

struct SUSegmentPicker_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            SUColorStandartPalette.background
                .ignoresSafeArea()
            SUSegmentPicker(
                selectedIndex: .constant(0),
                segments: [
                    "One", "Two", "Three"
                ]
            )
        }
    }
}
