import UIKit

final class RegistrationController: UIViewController {

    private var registrationView: RegistrationView {
        view as! RegistrationView
    }
    private var viewModel: RegistrationViewModel

    private var textFieldDelegate: UITextFieldDelegate!

    init(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        view = RegistrationView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDelegate()
    }
}

private extension RegistrationController {

    func setupDelegate() {
        /*textFieldDelegate = TextFieldDelegate(
            phoneNumberField: registrationView.phoneNumberField,
            passwordField: registrationView.passwordFieldFirst,
            confirmPasswordField: registrationView.passwordFieldSecond)
        registrationView.setDelegateToTextFields(textFieldDelegate)*/
    }
}
