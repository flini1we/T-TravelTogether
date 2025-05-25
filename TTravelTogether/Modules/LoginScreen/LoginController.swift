import UIKit
import Combine

final class LoginController: UIViewController {
    weak var coordinator: IAuthCoordinator?

    private var loginView: ILoginView {
        view as! ILoginView
    }
    private var viewModel: ILoginViewModel

    private lazy var goToRegistrationScreenAction: UIAction = {
        UIAction { [weak self] _ in
            self?.coordinator?.goToRegistration()
        }
    }()
    private lazy var loginAction: UIAction = {
        UIAction { [weak self] _ in
            guard let self else { return }
            let (phone, password) = loginView.getData()
            viewModel.login(phoneNumber: phone, password: password) { [weak self] result in
                self?.handleLoginResult(result)
            }
        }
    }()
    private var textFieldDelegate: UITextFieldDelegate?
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: ILoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        super.loadView()

        view = LoginView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension LoginController {

    func handleLoginResult(_ result: Result<String, LoginErrors>) {
        switch result {
        case .success(let user):
            coordinator?.onLoginSuccess(user)
            loginView.errorMessageTitle.text = ""
        case .failure(let error):
            loginView.errorMessageTitle.text = error.getError
        }
    }

    func setup() {
        setupBindings()
        setupDelegates()
        setupActions()
        setupNavigationTitle()
    }

    func setupBindings() {
        viewModel.isLoadingPublisher
            .dropFirst()
            .sink { [weak self] isLoading in
                guard let self else { return }
                loginView.showLoadingIndicator(isLoading)
                loginView.toggleTransparentBGVisibility()
            }.store(in: &cancellables)
    }

    func setupDelegates() {
        textFieldDelegate = LoginTextFieldDelegate(
            phoneNumberField: loginView.phoneNumberField,
            passwordField: loginView.passwordField)
        loginView.phoneNumberField.delegate = textFieldDelegate
        loginView.passwordField.delegate = textFieldDelegate
    }

    func setupActions() {
        loginView.setupGoToRegistrationPageAction(goToRegistrationScreenAction)
        loginView.setupLoginAction(loginAction)
    }

    func setupNavigationTitle() {
        navigationItem.titleView = loginView.loginViewTitle
    }
}
