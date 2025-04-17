import UIKit
import SnapKit

final class TextFieldBuilder: TextFieldBuildable {

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

    func paddinLeft(_ left: CGFloat) -> Self {
        let paddingView = UIView(frame: .init(x: 0, y: 0, width: left, height: 1))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return self
    }

    func clearButtonEnable() -> Self {
        textField.clearButtonMode = .whileEditing
        return self
    }

    func enableTogglingSecure() -> Self {
        textField.addEyeToggle()
        textField.textContentType = .password
        return self
    }

    func tag(_ tag: Int) -> Self {
        textField.tag = tag
        return self
    }

    func build() -> UITextField {
        textField
    }
}

private extension TextFieldBuilder {

    func setupPlainTextField() {

        textField.backgroundColor = .secondaryBG
        textField.textColor = .label
        textField.attributedPlaceholder = NSAttributedString(
            string: textField.placeholder ?? "",
            attributes: [.foregroundColor: UIColor.placeholder]
        )

        textField.snp.makeConstraints { make in
            make.height.equalTo(UIElementsValues.textFieldHeight.value)
        }
    }
}
