import UIKit

final class TextFieldBuilder {

    private var textField: UITextField

    init() {
        self.textField = UITextField()
        setupPlainTextField()
    }

    func placeHolder(_ text: String) -> Self {
        textField.placeholder = text
        return self
    }

    func keyboardType(_ type: UIKeyboardType) -> Self {
        textField.keyboardType = type
        return self
    }

    func returnKeyType(_ type: UIReturnKeyType) -> Self {
        textField.returnKeyType = type
        return self
    }

    func isSecureEntry(_ secure: Bool) -> Self {
        textField.isSecureTextEntry = secure
        return self
    }

    func delegete(_ delegate: UITextFieldDelegate) -> Self {
        textField.delegate = delegate
        return self
    }

    func cornerRadius(_ cr: PaddingValues) -> Self {
        textField.layer.cornerRadius = cr.value
        return self
    }

    func font(_ font: UIFont) -> Self {
        textField.font = font
        return self
    }

    func build() -> UITextField {
        textField
    }
}

private extension TextFieldBuilder {

    func setupPlainTextField() {

        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemGray6
        textField.textColor = .label
        textField.clearButtonMode = .whileEditing
    }
}
