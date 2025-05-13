import Foundation

enum RegularExpressions {
    case russianPhoneNumber, password

    var expression: String {
        switch self {
        case .russianPhoneNumber:
            return #"^(\+79\d{9}|89\d{9})$"#
        case .password:
            return "^(?=.*[A-Z])(?=.*\\d).{6,15}$"
        }
    }
}
