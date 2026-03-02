import SwiftUI

typealias DialogueScene = [DialogueCase: [String]]

enum DialogueCase {
	case question1
	case question2
	case introduction
	case excellentScore
	case goodScore
	case badScore
}

@Observable
@MainActor final class DialogueViewModel {
	private let dialogues: DialogueScene

	// Dialogue Control
	private var currentDialogueCase: DialogueCase = .introduction
	private var currentDialogues: [String] {
		dialogues[currentDialogueCase] ?? []
	}
	var currentDialogue: String {
		currentDialogues[currentIndex]
	}
	private var currentIndex = 0
	private(set) var isDialogueActive = false

	// Buttons control
	var isNextButtonEnabled: Bool {
		currentIndex < currentDialogues.count - 1
	}
	var isPreviousButtonEnabled: Bool {
		currentIndex > 0
	}
	var isEndOfDialogue: Bool {
		currentIndex == currentDialogues.count - 1
	}

	init () {
		dialogues = dialogueScenes
	}

	func setCurrentDialogueCase(_ dialogueCase: DialogueCase) {
		currentDialogueCase = dialogueCase
		currentIndex = 0
		isDialogueActive = true
	}

	func finishDialogue() {
		isDialogueActive = false
	}

	func advanceDialogue() {
		currentIndex += 1
	}

	func previousDialogue() {
		currentIndex -= 1
	}
}

private let dialogueScenes: DialogueScene = [
	.introduction: [
		"You forgot your water bottle in the locker room, so you went back to get the bottle",
		"When you found your bottle, an earthquake hit, and a heavy locker slid over, blocking the exit door",
		"You notice that the people are evacuating, now you need to find away to get out",
		"Good luck!"
	],
	.question1: [
		"You find a straight iron bar of 8 dm (80 cm).",
		"To use it as a lever, he must bend it at the correct height so it fits perfectly under the locker",
		"The correct bending height is given by the equation:",
		"x^2 - 5x - 24 = 0",
		"Choose the physically possible value."
	],
	.excellentScore: [
		"You bend the iron bar correctly and slide it under the lockers, using it as a lever.",
		"The locker shifts slightly, and you can now exit the room!",
		"Congratulations! You escaped safe and sound—with your favorite water bottle in hand!"
	],
	.goodScore: [
		"You bend the iron bar just enough to slide it under the locker and use it as a lever",
		"The locker moves, creating a small gap, and you manage to escape.",
		"Good job — but as you squeeze through the gap, you get injured, and your favorite water bottle rolls away. Better luck next time!"
	],
	.badScore: [
		"You bend the iron bar, but it’s not enough to slide it under the locker.",
		"When you try to use it as a lever, the iron bar snaps with a loud crack. ",
		"The noise catches the attention of a teacher who was checking the area, and he helps you get out.",
		"You should study more—next time, you might not be this lucky!"
	]
]
