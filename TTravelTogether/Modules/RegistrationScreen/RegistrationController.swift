import UIKit
import Combine

final class RegistrationController: UIViewController {
    var registerButtonAction: ((String) -> Void)?

    private var registrationView: IRegistrationView {
        view as! IRegistrationView
    }
    private var viewModel: IRegistrationViewModel

    private lazy var registerAction: UIAction = {
        UIAction { [weak self] _ in
            self?.viewModel.register(completion: { result in
                switch result {
                case .success(let user):
                    self?.registerButtonAction?(user)
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            })
        }
    }()

    private var textFieldDelegate: UITextFieldDelegate!
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: IRegistrationViewModel) {
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

        setupBindings()
        setupDelegate()
        setUpActions()
    }
}

private extension RegistrationController {

    func setupDelegate() {
        textFieldDelegate = TextFieldDelegate(
            phoneNumberField: registrationView.phoneNumberField,
            passwordField: registrationView.passwordFieldFirst,
            confirmPasswordField: registrationView.passwordFieldConfirmed)
        registrationView.phoneNumberField.delegate = textFieldDelegate
        registrationView.passwordFieldFirst.delegate = textFieldDelegate
        registrationView.passwordFieldConfirmed.delegate = textFieldDelegate
    }

    func setupBindings() {

        setupPhoneFieldBinding()
        setupPasswordFieldBinding()
        setupPasswordConfirmationFieldBinding()
        setupDataValidationBinding()
        setupLoadingBindings()
    }

    func setupPhoneFieldBinding() {

        viewModel.isPhoneValidPublisher
            .dropFirst()
            .sink { [weak self] isValid in
                self?.registrationView.phoneNumberField.setValidationBorder(isValid)
            }.store(in: &cancellables)

        registrationView
            .phoneNumberField
            .textPublisher
            .sink { [weak self] phoneNumber in
                guard let self else { return }
                _ = viewModel.validatePhone(phoneNumber)
                registrationView.phoneNumberFieldHint.text = viewModel.getPhoneErrorMessage(phoneNumber)
            }.store(in: &cancellables)
    }

    func setupPasswordFieldBinding() {

        viewModel.isPasswordValidPublisher
            .dropFirst()
            .sink { [weak self] isValid in
                self?.registrationView.passwordFieldFirst.setValidationBorder(isValid)
            }.store(in: &cancellables)

        registrationView
            .passwordFieldFirst
            .textPublisher
            .sink { [weak self] password in
                guard let self else { return }
                _ = viewModel.validatePassword(password)
                registrationView.passwordFieldHint.text = viewModel.getPasswordErrorMessage(password)
            }.store(in: &cancellables)
    }

    func setupPasswordConfirmationFieldBinding() {

        viewModel.isPasswordConfirmedPublisher
            .dropFirst()
            .sink { [weak self] isValid in
                self?.registrationView.passwordFieldConfirmed.setValidationBorder(isValid)
            }.store(in: &cancellables)

        registrationView
            .passwordFieldConfirmed
            .textPublisher
            .sink { [weak self] confirmedPassword in
                guard let self else { return }
                _ = viewModel.validatePasswordEquality(original: registrationView.passwordFieldFirst.text, confirmed: confirmedPassword)
                registrationView.passwordFieldConfirmedHint.text = viewModel.getConfirmedPasswordErrorMessage()
            }.store(in: &cancellables)
    }

    func setupLoadingBindings() {

        viewModel.isFetchingRequestPublisher
            .dropFirst()
            .sink { [weak self] isLoadin in
                if isLoadin {
                    self?.registrationView.activateIndicator()
                } else {
                    self?.registrationView.deactivateIndicator()
                }
                self?.registrationView.toggleTransparentBGVisibility()
            }.store(in: &cancellables)
    }

    func setupDataValidationBinding() {

        viewModel.isDataValid.sink { [weak self] isValid in
            self?.registrationView.validateButton(isValid: isValid)
        }.store(in: &cancellables)
    }

    func setUpActions() {
        registrationView.addRegisterAction(registerAction)
    }
}
