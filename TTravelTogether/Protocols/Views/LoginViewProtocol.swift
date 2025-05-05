import UIKit

protocol LoginViewProtocol: AnyObject {

    var phoneNumberField: UITextField { get }
    var passwordField: UITextField { get }
    var errorMessageTitle: UILabel { get }
    var activityIndicator: ActivityIndicatorProtocol { get }
    var transparentBG: UIView { get }

    func setupGoToRegistrationPageAction(_ action: UIAction)
    func setupLoginAction(_ action: UIAction)
    func getData() -> (phone: String, password: String)
    func toggleTransparentBGVisibility()
    func activateIndicator()
    func deactivateIndicator()
}
