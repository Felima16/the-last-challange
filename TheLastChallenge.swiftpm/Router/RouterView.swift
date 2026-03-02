import SwiftUI

struct RootView: View {
	@StateObject private var router = Router()

	var body: some View {
		NavigationStack(path: $router.path) {
			HomeView()
				.navigationDestination(for: Route.self) { route in
					switch route {
					case .home:
						HomeView()
							.toolbar(.hidden, for: .navigationBar)
					case .tutorial:
						TutorialView()
							.toolbar(.hidden, for: .navigationBar)
					case .game:
						GameView(router: router)
							.toolbar(.hidden, for: .navigationBar)
					}
				}
		}
		.environmentObject(router)
	}
}
