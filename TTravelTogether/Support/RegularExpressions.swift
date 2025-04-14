import Foundation

enum RegularExpressions {
    case russianPhoneNumber, password

    var expression: String {
        switch self {
        case .russianPhoneNumber:
            return #"^(\+7\d{10}|8\d{10})$"#
        case .password:
            return "^(?=.*[A-Z])(?=.*\\d).{6,}$"
        }
    }
}
