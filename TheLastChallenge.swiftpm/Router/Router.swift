import Foundation
import SwiftUI

enum Route: Hashable {
	case home
	case tutorial
	case game
}

@MainActor
final class Router: ObservableObject {
	@Published var path = NavigationPath()

	func navigate(to route: Route) {
		path.append(route)
	}

	func navigateBack() {
		path.removeLast()
	}

	func navigateToRoot() {
		path.removeLast(path.count)
	}
}
