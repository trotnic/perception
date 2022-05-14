//
//  AccountScreen.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 8.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI
import SUDesign
import SUFoundation

struct AccountScreen {

  @StateObject var viewModel: AccountViewModel
  @State private var isEditing = false

  @FocusState private var nameIsFocused: Bool
  @Namespace private var namespace

  @State private var showSheet = false
  #if os(iOS)
  @State private var image: UIImage?
  #endif
}

extension AccountScreen: View {

  var body: some View {
    GeometryReader { proxy in
      SUColorStandartPalette.background
        .ignoresSafeArea()
      VStack(spacing: 16.0) {
        ZStack {
          VStack {
            SUButtonCircular(
              icon: "chevron.left",
              action: viewModel.backAction
            )
          }
          .padding(.leading, 16)
          .frame(maxWidth: .infinity, alignment: .leading)
          VStack {
            Text("Profile")
              .font(.custom("Comfortaa", size: 20).bold())
              .foregroundColor(SUColorStandartPalette.text)
          }
        }
        .padding(.top, 16)
        ProfileImage()
        if isEditing {
          EditingBlock(size: proxy.size)
        } else {
          GeneralBlock(size: proxy.size)
        }
      }
      .foregroundColor(SUColorStandartPalette.text)
    }
    .onAppear(perform: viewModel.loadAction)
#if os(iOS)
    .sheet(isPresented: $showSheet) {
      SUImagePicker(
        image: .init(
          get: {
            nil
          },
          set: { image in
            let data = image?.pngData()
            Task {
              await MainActor.run {
                viewModel.image = data
              }
            }
          }
        )
      )
    }
#endif
  }
}

private extension AccountScreen {

  @ViewBuilder
  func ProfileImage() -> some View {
    if viewModel.imagePath == nil {
      Circle()
        .fill(SUColorStandartPalette.tile)
        .frame(width: 100.0, height: 100.0)
        .overlay {
          Button {
            showSheet = true
          } label: {
            Image(systemName: "camera")
              .font(.system(size: 40.0).bold())
              .foregroundColor(SUColorStandartPalette.secondary3)
          }
          .disabled(!isEditing)
        }
    } else {
      AsyncImage(url: URL(string: viewModel.imagePath!)) { image in
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 100.0, height: 100.0)
          .clipShape(Circle())
      } placeholder: {
        Circle()
          .fill(SUColorStandartPalette.tile)
          .frame(width: 100.0, height: 100.0)
          .overlay {
            Button {
              showSheet = true
            } label: {
              Image(systemName: "camera")
                .font(.system(size: 40.0).bold())
                .foregroundColor(SUColorStandartPalette.secondary3)
            }
          }
      }
      .overlay {
        if isEditing {
          Circle()
            .fill(SUColorStandartPalette.tile.opacity(0.8))
            .frame(width: 100.0, height: 100.0)
            .overlay {
              Button {
                showSheet = true
              } label: {
                Image(systemName: "camera")
                  .font(.system(size: 40.0).bold())
                  .foregroundColor(SUColorStandartPalette.secondary1)
              }
            }
        }
      }
    }
  }

  @ViewBuilder func EditingBlock(size: CGSize) -> some View {
    VStack(spacing: 32.0) {
      Sheet()
        .padding(.horizontal, 16.0)
      SaveButton(size: size)
    }
    .frame(maxWidth: .infinity)
    .padding(.bottom, 16.0)
    .onTapGesture {
      withAnimation {
        nameIsFocused = false
      }
    }
  }

  @ViewBuilder func GeneralBlock(size: CGSize) -> some View {
    VStack(spacing: 16.0) {
      InfoBlock()
      Spacer()
      LogOutButton(size: size)
    }
    .padding(.horizontal, 16.0)
    .padding(.bottom, 16.0)
  }

  func InfoBlock() -> some View {
    VStack(spacing: 16.0) {
      VStack(spacing: 12.0) {
        Text(viewModel.username)
          .font(.custom("Cofmortaa", size: 28.0))
          .foregroundColor(SUColorStandartPalette.text)
        Text(viewModel.email)
          .font(.custom("Cofmortaa", size: 16.0))
          .foregroundColor(SUColorStandartPalette.secondary1)
        SUButtonStroke(text: "Edit profile") {
          withAnimation {
            isEditing = true
          }
        }
      }
      VStack(spacing: 24.0) {
        VStack(alignment: .leading, spacing: 12.0) {
          Text("Info")
            .font(.custom("Cofmortaa", size: 16.0).bold())
            .foregroundColor(SUColorStandartPalette.secondary1)
          VStack(spacing: 16.0) {
            Text(viewModel.username)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(16.0)
              .background(SUColorStandartPalette.tile)
              .cornerRadius(16.0)
          }
        }
        VStack(alignment: .leading, spacing: 12.0) {
          Text("Invites")
            .font(.custom("Cofmortaa", size: 16.0).bold())
            .foregroundColor(SUColorStandartPalette.secondary1)
          VStack(spacing: 16.0) {
            Button {
              viewModel.invitesAction()
            } label: {
              Text("Active invites")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16.0)
                .background(SUColorStandartPalette.tile)
                .cornerRadius(16.0)
            }
          }
        }
      }
    }
  }

  func Sheet() -> some View {
    ZStack {
      VStack(spacing: .zero) {
        HStack {
          SUButtonCircular(icon: "xmark") {
            withAnimation {
              isEditing = false
            }
          }
          .padding(.vertical, 20.0)
          Spacer()
          VStack {
            RoundedRectangle(cornerRadius: 10.0)
              .fill(SUColorStandartPalette.secondary2)
              .frame(width: 72.0, height: 4.0)
            Text("Edit profile")
              .font(.custom("Cofmortaa", size: 18.0))
              .foregroundColor(SUColorStandartPalette.text)
          }
          Spacer()
          SUButtonStroke(text: "Reset") {
            viewModel.resetAction()
          }
        }
        .padding(.horizontal, 16.0)

        ScrollView {
          VStack(spacing: 24.0) {
            VStack(alignment: .leading, spacing: 16.0) {
              Text("Username")
                .font(.custom("Cofmortaa", size: 16.0).bold())
                .foregroundColor(SUColorStandartPalette.secondary1)
              SUTextFieldCapsule(
                text: $viewModel.username,
                placeholder: "Username"
              )
              Text("Position")
                .font(.custom("Cofmortaa", size: 16.0).bold())
                .foregroundColor(SUColorStandartPalette.secondary1)
              SUTextFieldCapsule(
                text: $viewModel.position,
                placeholder: "Position"
              )
            }
            .padding(.horizontal, 16.0)
          }
        }
        .padding(.vertical, 20.0)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        Spacer()
      }
    }
    .frame(maxWidth: .infinity)
    .background(SUColorStandartPalette.background)
    .cornerStroke(
      20.0,
      corners: .allCorners,
      color: SUColorStandartPalette.tile
    )
  }

  func SaveButton(size: CGSize) -> some View {
    Button {
      viewModel.saveAction()
    } label: {
      Text("Save")
        .font(.custom("Cofmortaa", size: 20.0).bold())
        .foregroundColor(SUColorStandartPalette.text)
        .frame(maxWidth: size.width - 32)
        .frame(height: 56)
        .background(SUColorStandartPalette.tint)
        .cornerRadius(20.0)
    }
    .matchedGeometryEffect(id: "bottom_button", in: namespace)
  }

  func LogOutButton(size: CGSize) -> some View {
    Button {
      viewModel.logoutAction()
    } label: {
      Text("Log out")
        .font(.custom("Cofmortaa", size: 20.0).bold())
        .foregroundColor(SUColorStandartPalette.text)
        .frame(maxWidth: size.width - 32)
        .frame(height: 56)
        .background(SUColorStandartPalette.destructive)
        .cornerRadius(20.0)
    }
    .matchedGeometryEffect(id: "bottom_button", in: namespace)
  }
}

struct AccountScreenSS_Previews: PreviewProvider {

  static let viewModel = AccountViewModel(
    appState: SUAppStateProviderMock(),
    userManager: SUManagerUserPrimeMock(
      userId: { .empty },
      isAuthenticated: { false },
      user: {
        SUUser(
          meta: .init(id: .empty),
          username: "lol kekman",
          email: "lol.kekman@gmail.com",
          invites: [],
          avatarPath: nil
        )
      }
    ),
    userMeta: .empty
  )

  static var previews: some View {
    ZStack {
      AccountScreen(viewModel: viewModel)
    }
  }
}
