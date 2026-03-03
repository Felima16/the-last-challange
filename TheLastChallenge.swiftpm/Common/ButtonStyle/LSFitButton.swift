import SwiftUI

struct LSFitButton: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.font(.system(size: 28, weight: .bold))
			.padding()
			.background(Color(.lsLightBlue))
			.foregroundStyle(Color(.lsSecondary))
			.clipShape(RoundedRectangle(cornerRadius: 24))
			.overlay {
				RoundedRectangle(cornerRadius: 24)
					.stroke(Color(.lsPrimary), lineWidth: 3)
			}
			.scaleEffect(configuration.isPressed ? 0.8 : 1)
			.animation(.easeOut(duration: 0.2), value: configuration.isPressed)

	}
}
