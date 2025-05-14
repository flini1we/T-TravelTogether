import UIKit
import SnapKit

final class LoginView: UIView, ILoginView {
    // MARK: UIElements
    private lazy var primaryImageLabel: UIImageView = {
        let imageView = UIImageView(image: .primaryLogo)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.width / 2.5)
        }
        return imageView
    }()

    private lazy var secondaryImageLabel: UIImageView = {
        let imageView = UIImageView(image: .secondaryLogo)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.width / 8)
        }
        return imageView
    }()

    private(set) lazy var loginViewTitle: UILabel = {
        LabelBuilder()
            .font(CustomFonts.bold(FontValues.medium.value).font)
            .textColor(.label)
            .text(.AppStrings.Auth.loginTitle)
            .build()
    }()

    private(set) lazy var phoneNumberField: UITextField = {
        TextFieldBuilder()
            .font(.systemFont(ofSize: FontValues.default.value))
            .cornerRadius(.default)
            .isSecureEntry(false)
            .placeHolder(.AppStrings.Auth.phoneNumber)
            .returnKeyType(.continue)
            .keyboardType(.phonePad)
            .paddinLeft(PaddingValues.default.value)
            .tag(0)
            .build()
    }()

    private(set) lazy var passwordField: UITextField = {
        TextFieldBuilder()
            .font(.systemFont(ofSize: FontValues.default.value))
            .cornerRadius(.default)
            .isSecureEntry(true)
            .placeHolder(.AppStrings.Auth.password)
            .returnKeyType(.done)
            .paddinLeft(PaddingValues.default.value)
            .enableTogglingSecure()
            .tag(1)
            .build()
    }()

    private(set) lazy var errorMessageTitle: UILabel = {
        let label = UILabel()
        label.textColor = .primaryRed
        label.font = CustomFonts.default(FontValues.small.value).font
        return label
    }()

    private lazy var loginButton: UIButton = {
        ButtonBuilder()
            .tintColor(.buttonLabel)
            .font(CustomFonts.bold(FontValues.default.value).font)
            .backgroundColor(.primaryYellow)
            .title(.AppStrings.Auth.enter)
            .cornerRadius(.default)
            .build()
    }()

    private lazy var goToRegistrationButton: UIButton = {
        ButtonBuilder()
            .tintColor(.primaryBlue)
            .title(.AppStrings.Auth.toRegistration)
            .build()
    }()

    private(set) lazy var activityIndicator: IActivityIndicator = {
        let indicator = ActivityIndicatorView()
        indicator.alpha = 0
        indicator.animate()
        return indicator
    }()

    private(set) lazy var transparentBG: UIView = {
        let view = UIView()
        view.backgroundColor = .placeholder.withAlphaComponent(0.25)
        view.isHidden = true
        return view
    }()

    // MARK: StackView containers
    private lazy var fieldsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            phoneNumberField,
            passwordField
        ])
        stack.axis = .vertical
        stack.spacing = PaddingValues.default.value
        return stack
    }()

    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            loginButton,
            goToRegistrationButton
        ])
        stack.axis = .vertical
        stack.spacing = PaddingValues.default.value
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupGoToRegistrationPageAction(_ action: UIAction) {
        goToRegistrationButton.addAction(action, for: .touchUpInside)
    }

    func setupLoginAction(_ action: UIAction) {
        loginButton.addAction(action, for: .touchUpInside)
    }

    func getData() -> (phone: String, password: String) {
        (phoneNumberField.text ?? "", passwordField.text ?? "")
    }

    func toggleTransparentBGVisibility() {
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve) {
            self.transparentBG.isHidden.toggle()
        }
    }

    func showLoadingIndicator(_ isLoading: Bool) {
        activityIndicator.alpha = isLoading ? 1 : 0
    }
}

private extension LoginView {

    func setup() {
        backgroundColor = .systemBackground
        setupDismiss()
        setupSubviews()
        setupConstraints()
    }

    func setupSubviews() {
        addSubview(secondaryImageLabel)
        addSubview(primaryImageLabel)
        addSubview(fieldsStackView)
        addSubview(errorMessageTitle)
        addSubview(buttonsStackView)
        addSubview(transparentBG)
        addSubview(activityIndicator)
    }

    func setupConstraints() {
        secondaryImageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(PaddingValues.big.value)
        }

        primaryImageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(secondaryImageLabel.snp.bottom).inset(PaddingValues.default.value)
        }

        fieldsStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(PaddingValues.medium.value)
        }

        errorMessageTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(fieldsStackView.snp.bottom).offset(PaddingValues.small.value)
        }

        buttonsStackView.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(PaddingValues.medium.value)
            make.leading.trailing.equalToSuperview().inset(PaddingValues.medium.value)
        }

        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(UIElementsValues.activiryIndicator.value)
        }

        transparentBG.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
