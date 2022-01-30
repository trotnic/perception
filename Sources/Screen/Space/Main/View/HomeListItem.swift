//
//  HomeListItem.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 8.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

struct HomeListItem: View {

    let icon: String
    let headTitle: String
    let membersTitle: String
    let dateTitle: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(icon)
                        .font(.custom("Comfortaa", fixedSize: 18))
                    Text(headTitle)
                        .font(.custom("Comfortaa", fixedSize: 18))
                }
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "person.2")
                            .font(.system(size: 13))
                        Text(membersTitle)
                            .font(.custom("Comfortaa", fixedSize: 12))
                            .foregroundColor(.white)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background {
                                Capsule()
                                    .foregroundColor(Color(red: 104/255, green: 55/255, blue: 55/255))
                            }
                    }
                    HStack(spacing: 8) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 13))
                        Text(dateTitle)
                            .font(.custom("Comfortaa", fixedSize: 12))
                            .foregroundColor(.white)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background {
                                Capsule()
                                    .foregroundColor(Color(red: 104/255, green: 73/255, blue: 55/255))
                            }
                    }
                }

            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 20))
        }
        .padding(.vertical, 16)
        .padding(.leading, 16)
        .padding(.trailing, 12)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color(red: 39 / 255, green: 42 / 255, blue: 51 / 255))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(lineWidth: 1)
                .foregroundColor(.white.opacity(0.08))
        }
        .foregroundColor(.white)
        .frame(width: 343)
    }
}

struct HomeListItem_Previews: PreviewProvider {
    static var previews: some View {
        HomeListItem(
            icon: "🔥", headTitle: "The Amazing Cow-Man", membersTitle: "3 members", dateTitle: "10:21, December 10, 2021"
        )
    }
}
