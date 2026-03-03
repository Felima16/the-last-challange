import SwiftUI

struct PageView: View {
	@EnvironmentObject private var router: Router

	let title: String
	let description: String
	let isLast: Bool

	var body: some View {
		VStack(spacing: 20) {
			HStack {
				Spacer()

				Button {
					router.navigateBack()
				} label: {
					Image(systemName: "xmark")
						.font(.system(size: 28, weight: .bold))
				}
				.buttonStyle(IconButton())
				.padding(.horizontal, 40)
			}
			.padding(.top, 40)

			Spacer()

			HStack {
				Spacer()

				Text(title)
					.font(.title).bold()

				Spacer()
			}

			Text(description)
				.multilineTextAlignment(.center)

			if isLast {
				Button {
					router.navigate(to: .game)
				} label: {
					Text("Start")
						.font(.title.bold())
				}
				.buttonStyle(LSButton())
				.padding(.horizontal, 40)
			}

			Spacer()
		}
		.foregroundStyle(Color(.lsPrimary))
		.background(Color(.tutorialBackground))
	}
}

#Preview {
	PageView(title: "Hello", description: "World", isLast: false)
}
