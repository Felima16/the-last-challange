import SwiftUI

@Observable
@MainActor final class GameViewModel {
	private var router: Router
	var paperViewModel: PaperViewModel
	var dialogueViewModel: DialogueViewModel

	init(
		router: Router,
		paperViewModel: PaperViewModel = PaperViewModel(),
		dialogueViewModel: DialogueViewModel = DialogueViewModel()
	) {
		self.router = router
		self.paperViewModel = paperViewModel
		self.dialogueViewModel = dialogueViewModel
	}

	func openQuestion1() {
		dialogueViewModel.setCurrentDialogueCase(.question1)
	}
}
