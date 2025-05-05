import Foundation

enum LoginErrors: Error {
    case dataValidationError

    var getError: String {
        switch self {
        case .dataValidationError:
            return LoginErrorsConstants.wrongData
        }
    }

    private enum LoginErrorsConstants {
        static let wrongData: String = "Упс.. Неверный номер телефона или пароль"
    }
}
