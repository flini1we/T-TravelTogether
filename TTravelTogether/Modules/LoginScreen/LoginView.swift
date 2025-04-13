import UIKit
import SnapKit

final class LoginView: UIView {
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

    private(set) lazy var phoneNumberField: UITextField = {
        TextFieldBuilder()
            .font(.systemFont(ofSize: FontValues.default.value))
            .cornerRadius(.default)
            .isSecureEntry(false)
            .placeHolder("Номер телефона")
            .returnKeyType(.continue)
            .keyboardType(.default)
            .paddinLeft(PaddingValues.default.value)
            .clearButtonEnable()
            .tag(0)
            .build()
    }()

    private(set) lazy var passwordField: UITextField = {
        TextFieldBuilder()
            .font(.systemFont(ofSize: FontValues.default.value))
            .cornerRadius(.default)
            .isSecureEntry(true)
            .placeHolder("Пароль")
            .returnKeyType(.done)
            .paddinLeft(PaddingValues.default.value)
            .enableTogglingSecure()
            .tag(1)
            .build()
    }()

    private lazy var loginButton: UIButton = {
        ButtonBuilder()
            .tintColor(.buttonLabel)
            .backgroundColor(.primaryYellow)
            .title("Войти")
            .cornerRadius(.default)
            .build()
    }()

    private lazy var goToRegistrationButton: UIButton = {
        ButtonBuilder()
            .tintColor(.primaryBlue)
            .title("Регистрация")
            .build()
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
        addSubview(buttonsStackView)
    }

    func setupConstraints() {
        secondaryImageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
        }

        primaryImageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(PaddingValues.big.value)
        }

        fieldsStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(PaddingValues.medium.value)
        }

        buttonsStackView.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(PaddingValues.medium.value)
            make.leading.trailing.equalToSuperview().inset(PaddingValues.medium.value)
        }
    }
}
