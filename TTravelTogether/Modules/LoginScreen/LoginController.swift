import UIKit
import Combine

final class LoginController: UIViewController {

    private var loginView: LoginViewProtocol {
        view as! LoginViewProtocol
    }
    private var viewModel: Loginable

    private lazy var goToRegistrationScreenAction: UIAction = {
        UIAction { [weak self] _ in
            guard let self else { return }
            let rigistrationViewModel = RegistrationViewModel()
            let registrationController = RegistrationController(viewModel: rigistrationViewModel)
            navigationController?.pushViewController(registrationController, animated: true)
        }
    }()
    private lazy var loginAction: UIAction = {
        UIAction { [weak self] _ in
            guard let self else { return }
            let data = loginView.getData()
            viewModel.login(phoneNumber: data.phone, password: data.password) { [weak self] result in
                self?.handleLoginResult(result)
            }
        }
    }()
    private var textFieldDelegate: UITextFieldDelegate?
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: Loginable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        view = LoginView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
        setupDelegates()
        setupActions()
    }
}

private extension LoginController {

    func handleLoginResult(_ result: Result<String, Error>) {
        switch result {
        case .success(let user):
            loginView.errorMessageTitle.text = ""
        case .failure(let error):
            loginView.errorMessageTitle.text = (error as! LoginErrors).getError
        }
    }

    func setupBindings() {
        viewModel.isLoadingPublisher
            .dropFirst()
            .sink { [weak self] isLoading in
                guard let self else { return }
                isLoading ? loginView.activateIndicator() : loginView.deactivateIndicator()
                loginView.toggleTransparentBGVisibility()
            }.store(in: &cancellables)
    }

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
        loginView.setupLoginAction(loginAction)
    }
}
