import SwiftUI
import PencilKit
  
struct PaperView: UIViewRepresentable {
    let viewModel: PaperViewModel
    let canvasView = PKCanvasView()
    let toolPicker = PKToolPicker()
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        if viewModel.isShowToolPicker {
            canvasView.becomeFirstResponder()
        }
        
        return canvasView
    }
    
    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
        toolPicker.setVisible(viewModel.isShowToolPicker, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        if viewModel.isShowToolPicker {
            canvasView.becomeFirstResponder()
        } else {
            canvasView.resignFirstResponder()
        }

        if viewModel.shouldUpdateCanvas {
            viewModel.updatePaper(with: canvasView.drawing)
            canvasView.drawing = viewModel.papers[viewModel.currentPaper].drawing
        }
        
        if viewModel.shouldResetCanvas {
            canvasView.drawing = PKDrawing()
            viewModel.shouldResetCanvas = false
        }
        
        if viewModel.shouldRecognise {
            viewModel.sendImage(image: canvasView.drawing.image(from: canvasView.bounds, scale: UIScreen.main.scale))
        }
    }

    //MARK: - Coordinator
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var drawing: PKDrawing

        init(drawing: PKDrawing) {
            self.drawing = drawing
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            drawing = canvasView.drawing
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(drawing: viewModel.papers[viewModel.currentPaper].drawing)
    }
}

