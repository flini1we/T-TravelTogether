import UIKit

protocol TextFieldBuildable {

    func placeHolder(_ text: String) -> Self
    func keyboardType(_ type: UIKeyboardType) -> Self
    func returnKeyType(_ type: UIReturnKeyType) -> Self
    func isSecureEntry(_ secure: Bool) -> Self
    func delegete(_ delegate: UITextFieldDelegate) -> Self
    func cornerRadius(_ cr: PaddingValues) -> Self
    func font(_ font: UIFont) -> Self
    func paddinLeft(_ left: CGFloat) -> Self
    func clearButtonEnable() -> Self
    func enableTogglingSecure() -> Self
    func tag(_ tag: Int) -> Self
    func build() -> UITextField
}
