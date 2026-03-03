import SwiftUI

struct TutorialView: View {

	var body: some View {
		TabView {
			PageView(title: "Goal", description: "To escape the room, you should find an object that will help you escape.\n Since that idea here is a different way to do an exam, the puzzle is solve a Bhaskera problem. ", isLast: false)
			PageView(
				title: "How to play",
				description:"""
When you find the object, a dialogue box will display a quadratic (Bhaskara) problem. 
You will use the canvas to solve it.
YOU MUST HAVE THIS STRUCTURE:

2x^2 + 5x - 3 = 0
a = 2
b = 5
c = -3

Δ = 49

x1 = 0.5
x2 = -3 

You can make the calcs, but to validate the answer, the system need this structure
""",
				isLast: false
			)
			PageView(title: "Win / lose", description: "You win if you find the object and solve the Bhaskara problem. You lose if you don't.", isLast: true)
		}
		.background(Color(.tutorialBackground))
		.tabViewStyle(.page(indexDisplayMode: .always))
		.indexViewStyle(.page(backgroundDisplayMode: .always))
	}
}
