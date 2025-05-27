import Foundation

enum LoginErrors: Error {
    case dataValidationError, emptyUserError, registerError

    var getError: String {
        switch self {
        case .dataValidationError:
            return LoginErrorsConstants.wrongData
        case .emptyUserError:
            return LoginErrorsConstants.nilUser
        case .registerError:
            return LoginErrorsConstants.registerFailure
        }
    }

    private enum LoginErrorsConstants {
        static let wrongData: String = "Неверный номер телефона или пароль"
        static let nilUser: String = "Неверные данные пользователя"
        static let registerFailure: String = "Ошибка в момент регистрации"
    }
}
