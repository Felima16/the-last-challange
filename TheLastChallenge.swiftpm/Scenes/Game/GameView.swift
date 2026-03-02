import SwiftUI
import PencilKit

struct GameView: View {
	@State var viewModel: GameViewModel

	init(router: Router) {
		self.viewModel = GameViewModel(router: router)
	}

    var body: some View {
		VStack(spacing: 0) {
			ZStack {
				Image(.lockerRoom)
					.resizable()
					.scaledToFill()

				VStack {
					Spacer()

					Button(action: {
						viewModel.openQuestion1()
					}, label: {
						Image(.ironLastChallenge)
							.resizable()
							.scaledToFit()
							.shadow(radius: 60)
					})
					.frame(width: 240)
					.padding(.bottom, 32)
				}
			}

			PaperView(viewModel: viewModel.paperViewModel)
				.overlay {
					VStack {
						HStack {
							Button("Finish") {
								viewModel.paperViewModel.shouldRecognise = true
							}
							.buttonStyle(LSFitButton())
							
							Spacer()

							Button(action: {
								viewModel.paperViewModel.isShowToolPicker.toggle()
							}, label: {
								Image(systemName: "pencil.tip")
							})
							.buttonStyle(IconButton())
							.padding(.horizontal, 16)


							Button(action: {
								viewModel.paperViewModel.resetPaper()
							}, label: {
								Image(systemName: "trash")
							})
							.buttonStyle(IconButton())
						}
						.padding(.horizontal, 48)
						.padding(.top, 16)

						Spacer()
					}
				}
				.alert("Error", isPresented: $viewModel.paperViewModel.isShowingAlert) {
					Button("OK") {
						viewModel.paperViewModel.isShowToolPicker.toggle()
					}
				} message: {
					Text(viewModel.paperViewModel.message)
				}
        }
		.overlay(alignment: .center) {
			ZStack {
				if viewModel.dialogueViewModel.isDialogueActive {
					Color.black.opacity(0.7)
						.ignoresSafeArea()
						.transition(.opacity)
					DialogueView(viewModel: viewModel.dialogueViewModel)
						.transition(.scale.combined(with: .opacity))
				}
			}
			.animation(.easeInOut(duration: 0.4), value: viewModel.dialogueViewModel.isDialogueActive)
		}
		.ignoresSafeArea(.all)
    }
}

#Preview {
	@Previewable @StateObject var router = Router()

	GameView(router: router)
}
