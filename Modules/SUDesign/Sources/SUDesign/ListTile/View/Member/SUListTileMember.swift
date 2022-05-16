//
//  SUListTileMember.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 7.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

extension HorizontalAlignment {
  // swiftlint:disable identifier_name
  private enum IconsCentricAlignment : AlignmentID {
    static func defaultValue(in d: ViewDimensions) -> CGFloat {
      d[HorizontalAlignment.leading]
    }
  }
  static let centricAlignment = HorizontalAlignment(IconsCentricAlignment.self)
}

public struct SUListTileMember {

  private let content: Content
  private let action: () -> Void

  public init(
    content: Content,
    action: @escaping () -> Void
  ) {
    self.content = content
    self.action = action
  }
}

extension SUListTileMember: View {

  public var body: some View {
    Button(action: action) {
      HStack {
        VStack(
          alignment: .leading,
          spacing: 12
        ) {
          HStack(spacing: 12.0) {
            Avatar(imagePath: content.imagePath)
            VStack(
              alignment: .leading,
              spacing: 6.0
            ) {
              Text(content.title)
                .font(.custom("Cofmortaa", size: 18.0).weight(.semibold))
                .lineLimit(1)
              VStack(
                alignment: .centricAlignment,
                spacing: 4.0
              ) {
                ForEach(content.badges) { badge in
                  HStack {
                    Image(systemName: badge.icon)
                      .foregroundColor(.white)
                      .font(.system(size: 20.0))
                      .alignmentGuide(.centricAlignment, computeValue: { $0[HorizontalAlignment.center] })
                    Text(badge.title)
                      .padding(.vertical, 4.0)
                      .padding(.horizontal, 10.0)
                      .background(badge.color)
                      .cornerRadius(12.0)
                      .lineLimit(1)
                      .font(.custom("Cofmortaa", size: 14.0).weight(.semibold))
                  }
                }
              }
            }
          }
          .frame(maxWidth: .infinity, alignment: .leading)
        }
      }
      .padding(16)
      .foregroundColor(SUColorStandartPalette.text)
      .background {
        SUColorStandartPalette.tile
      }
      .mask {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
      }
      .overlay {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
          .stroke()
          .fill(.white.opacity(0.08))
      }
    }
    .buttonStyle(SUListTileButtonStyle())
  }
}

public extension SUListTileMember {

  struct Content {
    public let title: String
    public let imagePath: String?
    public let badges: [Badge]

    public init(
      title: String,
      imagePath: String?,
      badges: [Badge]
    ) {
      self.title = title
      self.imagePath = imagePath
      self.badges = badges
    }
  }

  struct Badge: Identifiable {
    public let id = UUID()
    public let title: String
    public let icon: String
    public let color: Color

    public init(
      title: String,
      icon: String,
      color: Color
    ) {
      self.title = title
      self.icon = icon
      self.color = color
    }
  }
}

// MARK: - Private interface

private extension SUListTileMember {

  // swiftlint:disable identifier_name
  @ViewBuilder
  func Avatar(imagePath: String?) -> some View {
    if imagePath == nil {
      AvatarPlaceholder()
    } else {
      AsyncImage(url: URL(string: imagePath!)) { image in
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 72.0, height: 72.0)
          .clipShape(Circle())
      } placeholder: {
        AvatarPlaceholder()
      }
    }
  }

  func AvatarPlaceholder() -> some View {
    Circle()
      .fill(SUColorStandartPalette.tile)
      .frame(width: 72.0, height: 72.0)
      .overlay {
        Image(systemName: "camera")
          .font(.system(size: 40.0).bold())
          .foregroundColor(SUColorStandartPalette.secondary3)
      }
  }
}

// MARK: - Preview

struct SUListTileMember_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      SUColorStandartPalette.background
        .ignoresSafeArea()
      SUListTileMember(
        content: SUListTileMember.Content(
          title: "Kek Lolman",
          imagePath: "https://pbs.twimg.com/media/FHKBfu1WQAckBSF.jpg",
          badges: [
            SUListTileMember.Badge(
              title: "software engineer",
              icon: "person",
              color: .cyan.opacity(0.4)
            ),
            SUListTileMember.Badge(
              title: "editor",
              icon: "gear",
              color: .green.opacity(0.4)
            )
          ]
        ),
        action: {}
      )
    }
  }
}
