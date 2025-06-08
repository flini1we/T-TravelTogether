import Foundation

final class RussianValidationService {

    static let shared = RussianValidationService()

    private init() { }

    func validate(phone: String) -> String {
        let digits = phone.filter { $0.isNumber }
        guard digits.count > 10 else { return phone }

        let startIndex = digits.index(digits.endIndex, offsetBy: -11)
        let last11Digits = String(digits[startIndex...])

        let areaCode = String(last11Digits.dropFirst().prefix(3))
        let firstPart = String(last11Digits.dropFirst(4).prefix(3))
        let secondPart = String(last11Digits.dropFirst(7).prefix(2))
        let thirdPart = String(last11Digits.dropFirst(9))

        return "+7 (\(areaCode)) \(firstPart)-\(secondPart)-\(thirdPart)"
    }

    func invalidate(phone: String) -> String {
        let digits = phone.filter { $0.isNumber }

        if digits.first == "7" {
            return "8" + String(digits.dropFirst(1))
        }
        return digits
    }

    func compareTwoPhones(_ o1: String, _ o2: String) -> Bool {
        RussianValidationService.shared.invalidate(phone: o1) == RussianValidationService.shared.invalidate(phone: o2)
    }
}
