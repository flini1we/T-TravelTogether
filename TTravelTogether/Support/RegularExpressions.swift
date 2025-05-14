import Foundation

enum RegularExpressions {
    case russianPhoneNumber, password

    var expression: String {
        switch self {
        case .russianPhoneNumber:
            return #"^(\+7|8)[\s\-]*(\(\d{3}\)|\d{3})[\s\-]*\d{3}[\s\-]*\d{2}[\s\-]*\d{2}$"#
        case .password:
            return "^(?=.*[A-Z])(?=.*\\d).{6,15}$"
        }
    }
}
