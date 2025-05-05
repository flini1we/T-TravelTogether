import Foundation

enum Currency: String {

    case ruble = "₽"
    case dollar = "$"
    case euro = "€"

    static func current() -> Currency {
        return .ruble
    }
}
