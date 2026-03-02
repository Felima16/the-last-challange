import SwiftUI

struct LSButton: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.padding()
			.frame(width: 240)
			.background(Color(.lsBlue))
			.foregroundStyle(Color(.lsSecondary))
			.clipShape(RoundedRectangle(cornerRadius: 16))
			.overlay {
				RoundedRectangle(cornerRadius: 16)
					.stroke(Color(.lsPrimary), lineWidth: 6)
			}
			.scaleEffect(configuration.isPressed ? 0.8 : 1)
			.animation(.easeOut(duration: 0.2), value: configuration.isPressed)

	}
}
