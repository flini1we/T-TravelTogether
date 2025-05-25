import Foundation

enum RegularExpressions {
    case russianPhoneNumber, password, userData

    var expression: String {
        switch self {
        case .russianPhoneNumber:
            #"^(\+7|8)[\s\-]*(\(\d{3}\)|\d{3})[\s\-]*\d{3}[\s\-]*\d{2}[\s\-]*\d{2}$"#
        case .password:
            "^(?=.*[A-Z])(?=.*\\d).{6,15}$"
        case .userData:
            "^[A-ZА-Я][A-Za-zА-Яа-я' -]*$"
        }
    }
}
