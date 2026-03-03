import Foundation
import PencilKit

struct Paper {
    let question: Question
    var drawing: PKDrawing
}

enum Question: CaseIterable {
    case one
    case two
}
