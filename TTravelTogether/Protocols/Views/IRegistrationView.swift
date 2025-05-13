import UIKit

protocol IRegistrationView: AnyObject {

    var phoneNumberField: UITextField { get }
    var phoneNumberFieldHint: UILabel { get }
    var passwordFieldFirst: UITextField { get }
    var passwordFieldHint: UILabel { get }
    var passwordFieldConfirmed: UITextField { get }
    var passwordFieldConfirmedHint: UILabel { get }
    var activityIndicator: IActivityIndicator { get }
    var transparentBG: UIView { get }

    func addRegisterAction(_ action: UIAction)
    func getData() -> (name: String, password1: String, password2: String)
    func validateButton(isValid: Bool)
    func toggleTransparentBGVisibility()
    func activateIndicator()
    func deactivateIndicator()
}
