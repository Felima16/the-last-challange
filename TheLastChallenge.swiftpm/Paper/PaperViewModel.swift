import SwiftUI
import PencilKit
import Vision

@Observable
class PaperViewModel {
    var papers: [Paper] = []
    var isShowToolPicker = false

    var previousPaper = 0
    var currentPaper = 0
    var shouldUpdateCanvas = false
    var shouldResetCanvas = false
    
    var shouldRecognise = false
    var textResult = ""

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
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                textResult = "No text found"
                return
            }
            
            self.processRecognizedText(observations)
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
    
    private func processRecognizedText(_ observations: [VNRecognizedTextObservation]) {
        var recognizedStrings: [String] = []
        
        for observation in observations {
            guard let topCandidate = observation.topCandidates(1).first else { continue }
            recognizedStrings.append(topCandidate.string)
        }
        
        textResult = recognizedStrings.joined(separator: " ")
        shouldRecognise = false
    }
}
