import UIKit

final class LoginController: UIViewController {

    private var loginView: LoginView {
        view as! LoginView
    }

    private lazy var goToRegistrationScreenAction: UIAction = {
        UIAction { [weak self] _ in
            guard let self else { return }
            // TODO: фабрика например viewModel'ей
            let rigistrationViewModel = RegistrationViewModel()
            let registrationController = RegistrationController(viewModel: rigistrationViewModel)
            navigationController?.pushViewController(registrationController, animated: true)
        }
    }()
    private var textFieldDelegate: UITextFieldDelegate?

    override func loadView() {
        super.loadView()

        view = LoginView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDelegates()
        setupActions()
    }
}

private extension LoginController {
    func setupDelegates() {
        textFieldDelegate = TextFieldDelegate(
            phoneNumberField: loginView.phoneNumberField,
            passwordField: loginView.passwordField,
            confirmPasswordField: nil)
        loginView.phoneNumberField.delegate = textFieldDelegate
        loginView.passwordField.delegate = textFieldDelegate
    }

    func setupActions() {
        loginView.setupGoToRegistrationPageAction(goToRegistrationScreenAction)
    }
}
