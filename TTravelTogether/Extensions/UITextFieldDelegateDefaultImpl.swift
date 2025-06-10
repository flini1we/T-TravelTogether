import UIKit

/// Default implemantation for method due to `secure` changing troubles
func secureFieldShouldChangeCharactersIn(
    textField: UITextField,
    range: NSRange,
    replacementString string: String
) -> Bool {
    guard let currentText = textField.text else { return false }
    let updatedText: String
    if let textRange = Range(range, in: currentText) {
        updatedText = currentText.replacingCharacters(in: textRange, with: string)
    } else {
        updatedText = string
    }
    textField.text = updatedText
    /// send notification manual
    NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: textField)
    return false
}

func formatPhoneNumberForPhoneFields(
    textField: UITextField,
    range: NSRange,
    replacementString string: String
) -> Bool {
    if string.isEmpty { return true }
    guard let currentText = textField.text else { return true }
    let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
    let digits = updatedText.filter { $0.isNumber }
    var formattedNumber = ""

    var cleanDigits = Array(digits)
    if !cleanDigits.isEmpty {
        let firstDigit = cleanDigits[0]
        if firstDigit == "8" {
            cleanDigits[0] = "7"
            formattedNumber = "+7"
        } else if firstDigit == "7" {
            formattedNumber = "+7"
        } else {
            formattedNumber = String(firstDigit)
        }
    }

    if !cleanDigits.isEmpty {
        if cleanDigits.count > 1 {
            let areaCode = String(cleanDigits[1..<min(4, cleanDigits.count)])
            if formattedNumber.hasPrefix("+") {
                formattedNumber += " (\(areaCode)) "
            } else {
                formattedNumber += " (\(areaCode)) "
            }
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
