import SwiftUI

final class MathEvaluation: Sendable {
    let mathParser = MathParser()

    // MARK: - Math Evaluation
    public func evaluateMathExpression(lines: [String]) async -> ResultEquation {
		var score = 0.0

		// Parsing student expression and getting the results
        let parsedResult = await mathParser.parseStudentExpression(lines: lines)

        guard let equation = parsedResult.equation else {
            let errorMessage = """
            ❌ NO EQUATION FOUND
            Please write your equation clearly
            Examples:
            • 2x^2 + 5x - 3 = 0
            • x^2 - 4x + 3 = 0
            """
            return .failure(errorMessage)
        }

        print("📝 Equation: \(equation)")

        // Extract correct coefficients from equation
		let correctCoeffs = await mathParser.extractEquationCoefficients(equation)

		guard let correctA = correctCoeffs?.coeffA,
				let correctB = correctCoeffs?.coeffB,
				let correctC = correctCoeffs?.coeffC
		else {
			return .failure("❌ Could not parse equation")
		}

		score += evaluateCoefficient(studentInput: parsedResult.coeffs.coeffA, correctValue: correctA)
		score += evaluateCoefficient(studentInput: parsedResult.coeffs.coeffB, correctValue: correctB)
		score += evaluateCoefficient(studentInput: parsedResult.coeffs.coeffC, correctValue: correctC)

		// Verify Delta
		let correctDelta = correctB * correctB - 4 * correctA * correctC

		if let delta = parsedResult.delta {
			if abs(delta - correctDelta) < 0.001 {
				score += 35.0
			} else {
				print("❌ Your Δ = \(delta)")
			}
		} else {
			print("⚠️ Δ not found")
		}

		// Verify Root
		score += evaluateRoots(
			studentResul: parsedResult,
			correctA: correctA,
			correctB: correctB,
			correctDelta: correctDelta
		)

		return .success(score)
    }
    
    private func evaluateCoefficient(studentInput: Double?, correctValue: Double) -> Double {
		if let studentInput {
			if abs(studentInput - correctValue) < 0.001 {
				return 5.0
			} else {
				print("❌ a = \(studentInput) (should be \(correctValue))")
			}
		} else {
			print("⚠️  a = \(correctValue) (not found)")
		}
		return 0.0
	}

	private func evaluateRoots(
		studentResul: ResultEntity,
		correctA: Double,
		correctB: Double,
		correctDelta: Double
	) -> Double {
		var score = 0.0
		if correctDelta >= 0 {
			let sqrtDelta = sqrt(correctDelta)
			let correctX1 = (-correctB + sqrtDelta) / (2 * correctA)
			let correctX2 = (-correctB - sqrtDelta) / (2 * correctA)

			if let x1 = studentResul.x1 {
				if abs(x1 - correctX1) < 0.01 {
					score += 25.0
				} else {
					print("❌ Your x₁ = \(x1)")
				}
			} else {
				print("⚠️ x₁ not found")
			}

			if correctDelta > 0.001 {
				if let x2 = studentResul.x2 {
					if abs(x2 - correctX2) < 0.01 {
						score += 25.0
					} else {
						print("❌ Your x₂ = \(x2)")
					}
				} else {
					print("⚠️ x₂ not found")
				}
			}
		}
		return score
	}
}
