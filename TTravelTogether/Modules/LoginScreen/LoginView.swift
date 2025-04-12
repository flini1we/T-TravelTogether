import UIKit
import SnapKit

final class LoginView: UIView {

    private lazy var phoneNumberField: UITextField = {
        TextFieldBuilder()
            .font(.systemFont(ofSize: FontValues.default.value))
            .cornerRadius(.default)
            .isSecureEntry(false)
            .placeHolder("Номер телефона")
            .returnKeyType(.continue)
            .build()
    }()

    private lazy var passwordField: UITextField = {
        TextFieldBuilder()
            .font(.systemFont(ofSize: FontValues.default.value))
            .cornerRadius(.default)
            .isSecureEntry(true)
            .placeHolder("Пароль")
            .returnKeyType(.done)
            .build()
    }()

    private lazy var loginButton: UIButton = {
        ButtonBuilder()
            .cornerRadius(.default)
            .textColor(.label)
            .tintColor(.systemYellow)
            .title("Войти")
            .build()
    }()

    private lazy var goToRegistrationButton: UIButton = {
        ButtonBuilder()
            .textColor(.systemBlue)
            .title("Регистрация")
            .build()
    }()
}
