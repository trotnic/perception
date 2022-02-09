//
//  AccountScreen.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 8.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

struct AccountScreen: View {

    @StateObject var viewModel: AccountViewModel

    var body: some View {
        GeometryReader { proxy in
            ColorProvider.background
                .ignoresSafeArea()
            VStack {
                ZStack {
                    VStack {
                        SUButton(icon: "chevron.left", action: viewModel.backAction)
                    }
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .padding(.top, 16)
                VStack(spacing: 32.0) {
                    Text("Kek Lolman")
                    Text("kek.lolman@gmail.com")
                    Spacer()
                    Button {
                        viewModel.logoutAction()
                    } label: {
                        Text("Log out")
                            .font(.system(size: 20.0).weight(.bold))
                            .foregroundColor(ColorProvider.text)
                            .frame(maxWidth: proxy.size.width - 32)
                            .frame(height: 56)
                            .background(ColorProvider.destructive)
                            .cornerRadius(20.0)
                    }

                }
                .padding(16.0)
            }
            .foregroundColor(ColorProvider.text)
        }
    }
}

struct AccountScreen_Previews: PreviewProvider {

    static let viewModel = AccountViewModel(environment: .preview)

    static var previews: some View {
        AccountScreen(viewModel: viewModel)
    }
}
