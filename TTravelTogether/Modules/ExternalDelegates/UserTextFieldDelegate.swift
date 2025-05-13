import UIKit

final class UserTextFieldDelegate: NSObject, UITextFieldDelegate {

    private let phoneNumberField: UITextField
    private let passwordField: UITextField
    private let confirmPasswordField: UITextField?

    init(
        phoneNumberField: UITextField,
        passwordField: UITextField,
        confirmPasswordField: UITextField?
    ) {
        self.phoneNumberField = phoneNumberField
        self.passwordField = passwordField
        self.confirmPasswordField = confirmPasswordField
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        defaultShouldChangeCharactersIn(textField: textField, range: range, replacementString: string)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case phoneNumberField:
            passwordField.becomeFirstResponder()
        case passwordField:
            if let confirmPasswordField {
                confirmPasswordField.becomeFirstResponder()
            } else {
                passwordField.resignFirstResponder()
            }
        case confirmPasswordField:
            confirmPasswordField?.resignFirstResponder()
        default: return true
        }
        return true
    }
}
