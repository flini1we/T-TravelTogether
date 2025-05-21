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
        return textField == phoneNumberField
        ? formatPhoneNumber(textField: textField, range: range, replacementString: string)
        : secureFieldShouldChangeCharactersIn(textField: textField, range: range, replacementString: string)
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

private extension UserTextFieldDelegate {

    func formatPhoneNumber(textField: UITextField, range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty { return true }

        guard let currentText = textField.text else { return true }
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        let digits = updatedText.filter { $0.isNumber }
        var formattedNumber = ""

        var cleanDigits = Array(digits)
        if !digits.isEmpty {
            let firstDigit = digits[digits.startIndex]
            if firstDigit == "7" {
                cleanDigits = Array("8" + digits.dropFirst())
            }
        }

        if !cleanDigits.isEmpty {
            let firstDigit = cleanDigits[0]
            formattedNumber = "\(firstDigit)"

            if cleanDigits.count > 1 {
                let areaCode = String(cleanDigits[1..<min(4, cleanDigits.count)])
                formattedNumber += "(\(areaCode))"
            }
            if cleanDigits.count > 4 {
                let nextPart = String(cleanDigits[4..<min(7, cleanDigits.count)])
                formattedNumber += "\(nextPart)-"
            }
            if cleanDigits.count > 7 {
                let lastPart = String(cleanDigits[7..<min(9, cleanDigits.count)])
                formattedNumber += "\(lastPart)"
            }
            if cleanDigits.count > 9 {
                let extraPart = String(cleanDigits[9..<min(11, cleanDigits.count)])
                formattedNumber += "-\(extraPart)"
            }
        }

        textField.text = formattedNumber
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: textField)
        return false
    }
}
