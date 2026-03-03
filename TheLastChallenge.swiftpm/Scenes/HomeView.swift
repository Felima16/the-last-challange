import SwiftUI

struct HomeView: View {
	@EnvironmentObject private var router: Router

	var body: some View {
		ZStack {
			Image(.backgroundMath)
				.resizable()
				.scaledToFill()

			VStack {

				Spacer()

				Text("Last\n Challange")
					.multilineTextAlignment(.center)
					.font(.system(size: 80, weight: .bold, design: .rounded))
					.foregroundColor(Color(.lsSecondary))
					.padding(.bottom, 80)

				VStack(spacing: 24) {
					Button {
						router.navigate(to: .game)
					} label: {
						Text("Play")
							.font(.title.bold())
					}

					Button {
						router.navigate(to: .tutorial)
					} label: {

						Text("Tutorial")
							.font(.title.bold())
					}
				}
				.buttonStyle(LSButton())

				Spacer()
			}
		}
		.ignoresSafeArea(.all)
		.foregroundStyle(Color(.lsSecondary))
	}
}
