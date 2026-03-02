import SwiftUI
 
struct IconButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
			.font(.system(size: 28, weight: .bold))
			.padding()
			.background(Color(.lsLightBlue))
			.foregroundStyle(Color(.lsSecondary))
            .clipShape(Circle())
			.overlay {
				Circle()
					.stroke(Color(.lsPrimary), lineWidth: 3)
			}
			.scaleEffect(configuration.isPressed ? 0.8 : 1)
            .animation(.easeOut(duration: 0.3), value: configuration.isPressed)
    }
}
