struct Coefficients{
    var coeffA: Double?
    var coeffB: Double?
    var coeffC: Double?
}

struct ResultEntity {
    var equation: String?
    var coeffs: Coefficients
    var delta: Double?
    var x1: Double?
    var x2: Double?
}

enum ResultEquation {
    case success(Double)
    case failure(String)
}
