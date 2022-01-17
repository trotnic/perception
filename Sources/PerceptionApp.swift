import SwiftUI


@main
struct PerceptionApp: App {
    @StateObject var environment: Environment = .dev

	var body: some Scene {
		WindowGroup {
//            RootScreen()
//                .environmentObject(environment.state)
            WorkspaceScreen()
		}
	}
}
