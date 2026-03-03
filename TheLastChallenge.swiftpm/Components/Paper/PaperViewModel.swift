import SwiftUI
import PencilKit
import Vision

@Observable
@MainActor final class PaperViewModel {
    let mathEvaluator = MathEvaluation()

	var papers: [Paper] = []
	var isShowToolPicker = false

    var previousPaper = 0
    var currentPaper = 0
    var shouldUpdateCanvas = false
    var shouldResetCanvas = false
    
    var shouldRecognise = false
    var textResult = ""

	// Error
	var message = ""
	var isShowingAlert = false

    init() {
        for question in Question.allCases {
            let newPaper = Paper(question: question, drawing: PKDrawing())
            papers.append(newPaper)
        }
    }

    func openPaper(for question: Question) {
        guard let index = papers.firstIndex(where: { $0.question == question }), currentPaper != index else {
            return
        } 
        previousPaper = currentPaper
        currentPaper = index
        shouldUpdateCanvas = true
    }

    func updatePaper(with drawing: PKDrawing) {
        papers[previousPaper].drawing = drawing
        shouldUpdateCanvas = false
    }
    
    func resetPaper() {
        shouldResetCanvas = true
    }
    
    // MARK: - Vision Recognition
    func sendImage(image: UIImage) {
        recognizeText(from: image)
    }
    
    private func recognizeText(from image: UIImage) {
        guard let cgImage = image.cgImage else {
            textResult = "Error: Could not process image"
            return
        }
        
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let self = self else { return }
            
            if let error = error {
                textResult = "Recognition error: \(error.localizedDescription)"
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation], !observations.isEmpty else {
                textResult = "No text found"
                return
            }
			Task {
				await self.processRecognizedText(observations)
			}
        }
        
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = false
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            textResult = "Failed to perform recognition"
        }
    }
    
	private func processRecognizedText(_ observations: [VNRecognizedTextObservation]) async {
        // Sort observations by vertical position (top to bottom)
        let sortedObs = observations.sorted { $0.boundingBox.origin.y > $1.boundingBox.origin.y }

        // Extract text lines
        var lines: [String] = []
        for obs in sortedObs {
            if let text = obs.topCandidates(1).first?.string {
                lines.append(text)
            }
        }

        shouldRecognise = false
		let result = await mathEvaluator.evaluateMathExpression(lines: lines)

		switch result {
		case .success(let value):
			textResult = "Result: \(value)"
		case .failure(let error):
			message = "Error: \(error)"
			isShowingAlert = true
		}
    }
}

