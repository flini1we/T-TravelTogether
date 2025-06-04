import UIKit
import Combine
import Alamofire

final class RegistrationController: UIViewController, KeyboardObservable {

    var registerButtonAction: (() -> Void)?

    private var registrationView: IRegistrationView {
        view as! IRegistrationView
    }
    private var viewModel: IRegistrationViewModel
    var keyboardObserver: KeyboardObserver?

    private lazy var registerAction: UIAction = {
        UIAction { [weak self] _ in
            guard let self else { return }
            viewModel.register(user: getUser(), completion: { [weak self] result in
                self?.handleRegisterResult(result: result)
            })
        }
    }()

    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: IRegistrationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        super.loadView()

        view = RegistrationView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        stopKeyboardObservering()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getUser() -> UserDTO {
        let userTempData = registrationView.getUserData()
        return UserDTO(
            name: userTempData.name,
            lastName: userTempData.lastName,
            phoneNumber: RussianValidationService.shared.invalidate(phone: userTempData.phoneNumber),
            password: userTempData.password,
            passwordConfirmation: userTempData.confirmPassword
        )
    }
}

private extension RegistrationController {

    func handleRegisterResult(
        result : Result<String, CustomError>
    ) {
        switch result {
        case .success(let message):
            registerButtonAction?()
        case .failure(let customError):
            present(
                AlertFactory.createErrorAlert(
                    title: .AppStrings.Errors.registerError,
                    message: customError.message,
                    onDismiss: { }
                ), animated: true
            )
        }
        viewModel.isFetchingRequest = false
    }

    func setup() {
        setupObservers()
        setupBindings()
        setUpActions()
        setupNavigationItem()
    }

    func setupObservers() {

        startKeyboardObservering { [weak self] keyboardFrame in
            self?.registrationView.onKeyboardWillShow(frame: keyboardFrame)
        } onHide: { [weak self] in
            self?.registrationView.onKeyboardWillHide()
        }
    }

    func setupBindings() {

        setupUserDataFieldsBindings()
        setupPhoneFieldBinding()
        setupPasswordFieldBinding()
        setupPasswordConfirmationFieldBinding()
        setupDataValidationBinding()
        setupLoadingBindings()
    }

    func setupUserDataFieldsBindings() {

        viewModel.isUserNameValidPublisher
            .dropFirst()
            .sink { [weak self] isValid in
                self?.registrationView.userNameField.setValidationBorder(isValid)
            }
            .store(in: &cancellables)

        viewModel.isUserLastNameValidPublisher
            .dropFirst()
            .sink { [weak self] isValid in
                self?.registrationView.userLastNameField.setValidationBorder(isValid)
            }
            .store(in: &cancellables)

        registrationView
            .userNameField
            .textPublisher
            .sink { [weak self] userName in
                guard let self else { return }
                _ = viewModel.validateName(userName)
                registrationView.userNameHint.text = viewModel.getUserNameErorrMessage(userName)
            }
            .store(in: &cancellables)

        registrationView
            .userLastNameField
            .textPublisher
            .sink { [weak self] userLastName in
                guard let self else { return }
                _ = viewModel.validateLastName(userLastName)
                registrationView.userLastNameHint.text = viewModel.getUserLastNameErorrMessage(userLastName)
            }
            .store(in: &cancellables)
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

    func setupNavigationItem() {
        navigationItem.titleView = registrationView.registerViewTitle
    }
}
