import UIKit

protocol RegistrationViewProtocol: AnyObject {

    var phoneNumberField: UITextField { get }
    var passwordFieldFirst: UITextField { get }
    var passwordFieldSecond: UITextField { get }
    var activityIndicator: ActivityIndicatorProtocol { get }
    var transparentBG: UIView { get }

    func addRegisterAction(_ action: UIAction)
    func getData() -> (name: String, password1: String, password2: String)
    func validateButton(isValid: Bool)
    func toggleTransparentBGVisibility()
    func activateIndicator()
    func deactivateIndicator()
}
