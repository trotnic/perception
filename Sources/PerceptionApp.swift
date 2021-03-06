import SwiftUI
import SwiftUIRouter

@main
struct PerceptionApp: App {
  @StateObject var environment = SUEnvironment()

  var body: some Scene {
    WindowGroup {
      Router(navigator: environment.navigator) {
        RootScreen(
          environment: environment,
          viewModel: RootViewModel(
            appState: environment.appState,
            userManager: environment.userManager
          )
        )
      }
#if os(macOS)
      .frame(width: 400, height: 750)
#endif
    }
  }
}
