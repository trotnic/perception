//
//  SUSheet.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 5.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

public struct SUSheet {

    private let height: CGFloat
    private let title: String
    private let content: () -> [SUSheetItem]
//    @State private var offset: CGFloat = .zero

    public init(
        height: CGFloat,
        title: String,
        content: @escaping () -> [SUSheetItem]
    ) {
        self.height = height
        self.title = title
        self.content = content
    }
}

extension SUSheet: View {

    public var body: some View {
        ZStack {
            VStack(spacing: .zero) {
                HStack {
                    SUButtonCircular(icon: "xmark", action: {})
                        .padding(.vertical, 20.0)
                    Spacer()
                    VStack {
                        RoundedRectangle(cornerRadius: 10.0)
                            .fill(SUColorStandartPalette.secondary2)
                            .frame(width: 72.0, height: 4.0)
                        Text(title)
                            .font(.custom("Cofmortaa", size: 18.0))
                            .foregroundColor(SUColorStandartPalette.text)
                    }

                    Spacer()
                    SUButtonCircular(icon: "chevron.left", action: {})
                        .padding(.vertical, 20.0)
                }
                .padding(.horizontal, 16.0)
                ScrollView {
                    VStack(spacing: 24.0) {
                        ForEach(content()) { item in
                            VStack(alignment: .leading, spacing: 16.0) {
                                Text(item.title)
                                    .font(.custom("Cofmortaa", size: 16.0).bold())
                                    .foregroundColor(SUColorStandartPalette.secondary1)
                                SUTextFieldCapsule(
                                    text: item.text,
                                    placeholder: item.placeholder
                                )
                            }
                            .padding(.horizontal, 16.0)
                        }
                        Spacer()
                    }
                }
                .padding(.vertical, 20.0)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .background(SUColorStandartPalette.background)
        .cornerStroke(
            20.0,
            corners: .allCorners,
            color: SUColorStandartPalette.tile
        )
    }
}

public extension SUSheet {

    struct SUSheetItem: Identifiable {
        public let id = UUID()
        let title: String
        let placeholder: String
        let text: Binding<String>

        public init(
            title: String,
            placeholder: String,
            text: Binding<String>
        ) {
            self.title = title
            self.placeholder = placeholder
            self.text = text
        }
    }
}

struct SUSheet_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            ZStack {
                SUColorStandartPalette.background
                    .ignoresSafeArea()
                VStack {
                    SUSheet(
                        height: proxy.size.height * 0.7389162562,
                        title: "Edit profile"
                    ) {
                        [
                            SUSheet.SUSheetItem(
                                title: "Name",
                                placeholder: "Some text",
                                text: .constant("Some text")
                            )
                        ]
                    }
                        .padding(.horizontal, 8.0)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
}
