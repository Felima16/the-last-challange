import SwiftUI

struct MathParser {
    // Parse student expression
    func parseStudentExpression(lines: [String]) async -> ResultEntity {
        var result = ResultEntity(coeffs: Coefficients())

        for line in lines {
            var cleaned = line
                .replacingOccurrences(of: " ", with: "")
                .lowercased()

            cleaned = await smartCorrectMath(cleaned)

            // Find equation
            if result.equation == nil && (cleaned.contains("x^2") || cleaned.contains("x²")) && cleaned.contains("=") {
                result.equation = cleaned
            }

            // Extract values with flexible parsing
            if cleaned.hasPrefix("a=") || cleaned.hasPrefix("ais") {
                result.coeffs.coeffA = await extractCoefficients(from: cleaned, with: "a")
            }
            if (cleaned.hasPrefix("b=") || cleaned.hasPrefix("bis")) && !cleaned.contains("b²") {
                result.coeffs.coeffB = await extractCoefficients(from: cleaned, with: "b")
            }
            if cleaned.hasPrefix("c=") || cleaned.hasPrefix("cis") {
                result.coeffs.coeffC = await extractCoefficients(from: cleaned, with: "c")
            }

            // Delta with multiple spellings
            if cleaned.contains("δ") || cleaned.contains("delta") || cleaned.contains("discriminant") || cleaned.contains("Δ") {
                result.delta = await extractLastNumber(from: cleaned)
            }

			// Roots
            if cleaned.contains("x₁") || cleaned.contains("x1") || cleaned.contains("xl") {
                result.x1 = await extractLastNumber(from: cleaned)
            }
            if cleaned.contains("x₂") || cleaned.contains("x2") || cleaned.contains("xz"){
                result.x2 = await extractLastNumber(from: cleaned)
            }
        }

        return result
    }

    func extractEquationCoefficients(_ equation: String) async -> Coefficients? {
        let expr = equation.replacingOccurrences(of: "²", with: "^2").lowercased()
        let parts = expr.components(separatedBy: "=")

        guard let leftSide = parts.first else {
            return nil
        }

        var a = 1.0
        var b = 0.0
        var c = 0.0

        // Extract a
        if let regex = try? NSRegularExpression(pattern: "([+-]?[0-9.]*)[x]\\^?2") {
            let nsString = leftSide as NSString
            if let match = regex.firstMatch(in: leftSide, range: NSRange(location: 0, length: nsString.length)) {
                let coef = nsString.substring(with: match.range(at: 1))
                if coef.isEmpty || coef == "+" { a = 1.0 }
                else if coef == "-" { a = -1.0 }
                else { a = Double(coef) ?? 1.0 }
            }
        }

        // Extract b
        if let regex = try? NSRegularExpression(pattern: "([+-]?[0-9.]*)[x](?!\\^?2)") {
            let nsString = leftSide as NSString
            if let match = regex.firstMatch(in: leftSide, range: NSRange(location: 0, length: nsString.length)) {
                let coef = nsString.substring(with: match.range(at: 1))
                if coef.isEmpty || coef == "+" { b = 1.0 }
                else if coef == "-" { b = -1.0 }
                else { b = Double(coef) ?? 0.0 }
            }
        }

        // Extract c
        if let regex = try? NSRegularExpression(pattern: "([+-][0-9.]+)(?![x])") {
            let nsString = leftSide as NSString
            let matches = regex.matches(in: leftSide, range: NSRange(location: 0, length: nsString.length))
            if let last = matches.last {
                let numStr = nsString.substring(with: last.range(at: 1))
                c = Double(numStr) ?? 0.0
            }
        }

        return Coefficients(coeffA: a, coeffB: b, coeffC: c)
    }

    private func smartCorrectMath(_ text: String) async -> String {
        var corrected = text

        // Number corrections
        corrected = corrected.replacingOccurrences(of: "o", with: "0")
        corrected = corrected.replacingOccurrences(of: "l", with: "1")
        corrected = corrected.replacingOccurrences(of: "i", with: "1")
        corrected = corrected.replacingOccurrences(of: "z", with: "2")

        // Quadratic term patterns
        let patterns: [(String, String)] = [
            ("x2", "x^2"), ("xz", "x^2"), ("x²", "x^2"),
            ("×", "*"), ("÷", "/")
        ]

        for (old, new) in patterns {
            corrected = corrected.replacingOccurrences(of: old, with: new)
        }

        return corrected
    }

    private func extractCoefficients(from text: String, with coefficient: String) async -> Double? {
        // Try "a=2" or "a = 2" or "a is 2"
        let patterns = [
            "\\b\(coefficient)=([+-]?[0-9.]+)",
            "\\b\(coefficient)\\s*=\\s*([+-]?[0-9.]+)",
            "\\b\(coefficient)\\s*is\\s*([+-]?[0-9.]+)"
        ]

        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern) {
                let nsString = text as NSString
                if let match = regex.firstMatch(in: text, range: NSRange(location: 0, length: nsString.length)) {
                    if match.numberOfRanges > 1 {
                        let valueStr = nsString.substring(with: match.range(at: 1))
                        return Double(valueStr)
                    }
                }
            }
        }
        return nil
    }

    private func extractLastNumber(from text: String) async -> Double? {
        let pattern = "[+-]?[0-9]+\\.?[0-9]*"
        if let regex = try? NSRegularExpression(pattern: pattern) {
            let nsString = text as NSString
            let matches = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            if let last = matches.last {
                let numStr = nsString.substring(with: last.range)
                return Double(numStr)
            }
        }
        return nil
    }
}
