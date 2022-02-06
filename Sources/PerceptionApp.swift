import SwiftUI
import SwiftUIRouter

@main
struct PerceptionApp: App {
    @StateObject var environment: Environment = .dev

	var body: some Scene {
		WindowGroup {
            Router(navigator: environment.navigator) {
                RootScreen(viewModel: RootViewModel())
            }
		}
	}
}
