import SwiftUI

struct DialogueView: View {
	let viewModel: DialogueViewModel

	var body: some View {
		VStack {
			Text(viewModel.currentDialogue)
				.font(.title)
				.padding(24)
				.foregroundStyle(Color(.lsSecondary))

			HStack {
				if viewModel.isPreviousButtonEnabled {
					Button {
						viewModel.previousDialogue()
					} label: {
						Image(systemName: "arrowshape.left.fill")
					}
					.buttonStyle(IconButton())

				}

				Spacer()

				if viewModel.isNextButtonEnabled {
					Button {
						viewModel.advanceDialogue()
					} label: {
						Image(systemName: "arrowshape.right.fill")
					}
					.buttonStyle(IconButton())
				}

				if viewModel.isEndOfDialogue {
					Button("Finish") {
						viewModel.finishDialogue()
					}
					.font(.title)
					.buttonStyle(LSFitButton())
				}
			}
			.padding()
		}
		.background(Color(.lsOliveGreen))
		.clipShape(RoundedRectangle(cornerRadius: 24))
		.overlay {
			RoundedRectangle(cornerRadius: 24)
				.stroke(Color(.lsPrimary), lineWidth: 6)
		}
		.padding(.horizontal, 120)
	}
}

#Preview {
	DialogueView(viewModel: DialogueViewModel())
}
