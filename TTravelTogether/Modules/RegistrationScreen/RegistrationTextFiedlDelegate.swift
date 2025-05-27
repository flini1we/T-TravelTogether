import UIKit

final class RegistrationTextFiedlDelegate: NSObject, UITextFieldDelegate {

    private var userNameFld: UITextField
    private var userLastNameFld: UITextField
    private var phoneNumber: UITextField
    private var password: UITextField
    private var passwordConfirmed: UITextField

    init(
        userNameFld: UITextField,
        userLastNameFld: UITextField,
        phoneNumber: UITextField,
        password: UITextField,
        passwordConfirmed: UITextField
    ) {
        self.userNameFld = userNameFld
        self.userLastNameFld = userLastNameFld
        self.phoneNumber = phoneNumber
        self.password = password
        self.passwordConfirmed = passwordConfirmed
        super.init()
        userNameFld.delegate = self
        userLastNameFld.delegate = self
        phoneNumber.delegate = self
        password.delegate = self
        passwordConfirmed.delegate = self
    }
}
