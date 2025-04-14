import UIKit
import SnapKit

final class RegistrationView: UIView {
    // MARK: UIElements
    private lazy var imageLabel: UIImageView = {
        let imageView = UIImageView(image: .registrationLogo)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private(set) lazy var phoneNumberField: UITextField = {
        TextFieldBuilder()
            .font(.systemFont(ofSize: FontValues.default.value))
            .cornerRadius(.default)
            .isSecureEntry(false)
            .keyboardType(.default)
            .placeHolder("Номер телефона")
            .returnKeyType(.continue)
            .paddinLeft(PaddingValues.default.value)
            .build()
    }()

    private(set) lazy var passwordFieldFirst: UITextField = {
        TextFieldBuilder()
            .font(.systemFont(ofSize: FontValues.default.value))
            .cornerRadius(.default)
            .isSecureEntry(true)
            .placeHolder("Пароль")
            .returnKeyType(.continue)
            .paddinLeft(PaddingValues.default.value)
            .enableTogglingSecure()
            .build()
    }()

    private(set) lazy var passwordFieldSecond: UITextField = {
        TextFieldBuilder()
            .font(.systemFont(ofSize: FontValues.default.value))
            .cornerRadius(.default)
            .isSecureEntry(true)
            .placeHolder("Повторите пароль")
            .returnKeyType(.done)
            .paddinLeft(PaddingValues.default.value)
            .enableTogglingSecure()
            .build()
    }()

    private lazy var registerButton: UIButton = {
        ButtonBuilder()
            .tintColor(.buttonLabel)
            .backgroundColor(.primaryYellow)
            .title("Зарегистрироваться")
            .cornerRadius(.default)
            .build()
    }()

    private(set) lazy var activityIndicator: ActivityIndicatorView = {
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
    private lazy var textFieldsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            phoneNumberField,
            passwordFieldFirst,
            passwordFieldSecond
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

    func addRegisterAction(_ action: UIAction) {
        registerButton.addAction(action, for: .touchUpInside)
    }

    func getData() -> (name: String, password1: String, password2: String) {
        (phoneNumberField.text ?? "", passwordFieldFirst.text ?? "", passwordFieldSecond.text ?? "")
    }

    func validateButton(isValid: Bool) {
        registerButton.alpha = isValid ? 1 : 0.5
        registerButton.isEnabled = isValid
    }

    func toggleTransparentBGVisibility() {
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve) {
            self.transparentBG.isHidden.toggle()
        }
    }

    func activateIndicator() {
        activityIndicator.alpha = 1
    }

    func deactivateIndicator() {
        activityIndicator.alpha = 0
    }
}

private extension RegistrationView {

    func setup() {
        backgroundColor = .systemBackground
        setupDismiss()
        setupSubviews()
        setupConstraints()
    }

    func setupSubviews() {
        addSubview(imageLabel)
        addSubview(textFieldsStackView)
        addSubview(registerButton)
        addSubview(transparentBG)
        addSubview(activityIndicator)
    }

    func setupConstraints() {
        imageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(PaddingValues.medium.value)
            make.height.equalTo(UIScreen.main.bounds.width / 2.5)
        }

        textFieldsStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(PaddingValues.medium.value)
        }

        registerButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(PaddingValues.medium.value)
            make.leading.trailing.equalToSuperview().inset(PaddingValues.default.value)
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
