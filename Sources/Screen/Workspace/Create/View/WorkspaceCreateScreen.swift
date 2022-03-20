//
//  WorkspaceCreateScreen.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 23.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI
import SUDesign
import SUFoundation

struct WorkspaceCreateScreen {

    @StateObject var viewModel: WorkspaceCreateViewModel
    @FocusState private var textFieldFocus
}

extension WorkspaceCreateScreen: View {

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                SUColorStandartPalette.background
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 24.0) {
                    ZStack {
                        VStack {
                            SUButtonCircular(
                                icon: "chevron.left",
                                action: viewModel.backAction
                            )
                                .frame(width: 36.0, height: 36.0)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        VStack {
                            Text("Create document")
                                .font(.custom("Comfortaa", size: 20.0).bold())
                                .foregroundColor(SUColorStandartPalette.text)
                        }
                    }
                    .padding(.top, 16.0)
                    .padding(.horizontal, 16.0)
                    VStack(spacing: 40.0) {
                        VStack(alignment: .center, spacing: 32.0) {
                            TopTile()
                                .frame(maxWidth: proxy.size.width - 32.0)
                            SUButtonCapsule(
                                isActive: $viewModel.isCreateButtonActive,
                                title: "Create",
                                size: CGSize(
                                    width: proxy.size.width - 32.0,
                                    height: 56.0
                                ),
                                action: viewModel.createAction
                            )
                            .animation(.easeInOut(duration: 0.12), value: viewModel.isCreateButtonActive)
                        }
                        Text("The name must contain no more than 25 characters")
                            .foregroundColor(SUColorStandartPalette.secondary1)
                            .font(.custom("Cofmortaa", size: 22.0).bold())
                            .frame(maxWidth: proxy.size.width - 60.0)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .onTapGesture {
            withAnimation {
                textFieldFocus = false
            }
        }
        .onAppear {
            Task {
                try await Task.sleep(nanoseconds: 300000000)
                await MainActor.run {
                    withAnimation {
                        textFieldFocus = true
                    }
                }
            }
        }
    }
}

private extension WorkspaceCreateScreen {

    @ViewBuilder
    func TopTile() -> some View {
        VStack(alignment: .leading, spacing: 16.0) {
            TextField(String.empty, text: $viewModel.name)
                .placeholder(when: viewModel.name.isEmpty) {
                    Text("Name document")
                        .foregroundColor(SUColorStandartPalette.secondary1)
                }
                .focused($textFieldFocus)
        }
        .foregroundColor(SUColorStandartPalette.text)
        .padding(16.0)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            SUColorStandartPalette.tile
        }
        .mask {
            RoundedRectangle(cornerRadius: 10.0)
        }
        .onTapGesture {
            withAnimation {
                textFieldFocus = true
            }
        }
    }
}

// MARK: - Preview

struct WorkspaceCreateScreen_Previews: PreviewProvider {

    static let viewModel = WorkspaceCreateViewModel(
        appState: SUAppStateProviderMock(),
        workspaceManager: SUManagerWorkspaceMock(),
        sessionManager: SUManagerUserPrimeMock(),
        workspaceMeta: .empty
    )

    static var previews: some View {
        ZStack {
            WorkspaceCreateScreen(viewModel: viewModel)
        }
    }
}
