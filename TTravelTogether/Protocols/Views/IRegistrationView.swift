import UIKit

protocol IRegistrationView: AnyObject {

    var registerViewTitle: UILabel { get }
    var userNameField: UITextField { get }
    var userNameHint: UILabel { get }
    var userLastNameField: UITextField { get }
    var userLastNameHint: UILabel { get }
    var phoneNumberField: UITextField { get }
    var phoneNumberFieldHint: UILabel { get }
    var passwordFieldFirst: UITextField { get }
    var passwordFieldHint: UILabel { get }
    var passwordFieldConfirmed: UITextField { get }
    var passwordFieldConfirmedHint: UILabel { get }
    var activityIndicator: IActivityIndicator { get }
    var transparentBG: UIView { get }

    func addRegisterAction(_ action: UIAction)
    func validateButton(isValid: Bool)
    func toggleTransparentBGVisibility()
    func activateIndicator()
    func deactivateIndicator()
    func onKeyboardWillShow(frame: CGRect)
    func onKeyboardWillHide()
    func getUserData() -> UserTempData
}
