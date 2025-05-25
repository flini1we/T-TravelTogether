import UIKit

final class LoginTextFieldDelegate: NSObject, UITextFieldDelegate {

    private let phoneNumberField: UITextField
    private let passwordField: UITextField

    init(
        phoneNumberField: UITextField,
        passwordField: UITextField
    ) {
        self.phoneNumberField = phoneNumberField
        self.passwordField = passwordField
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField == phoneNumberField
        ? formatPhoneNumberForPhoneFields(textField: textField, range: range, replacementString: string)
        : secureFieldShouldChangeCharactersIn(textField: textField, range: range, replacementString: string)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case phoneNumberField:
            passwordField.becomeFirstResponder()
        case passwordField:
            passwordField.resignFirstResponder()
        default:
            return true
        }
        return true
    }
}
