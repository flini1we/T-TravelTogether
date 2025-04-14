import Foundation

enum LoginErrors: Error {
    case dataValidationError

    var getError: String {
        switch self {
        case .dataValidationError:
            return "Упс.. Неверный номер телефона или пароль"
        }
    }
}
