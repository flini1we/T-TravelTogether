import UIKit

/// Default implemantation for method due to `secure` changing troubles
func defaultShouldChangeCharactersIn(textField: UITextField, range: NSRange, replacementString string: String) -> Bool {
    guard let currentText = textField.text else { return false }
    let updatedText: String
    if let textRange = Range(range, in: currentText) {
        updatedText = currentText.replacingCharacters(in: textRange, with: string)
    } else {
        updatedText = string
    }
    textField.text = updatedText
    return false
}
