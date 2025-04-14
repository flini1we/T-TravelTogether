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
            .clearButtonEnable()
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
            .delegete(self)
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
            .delegete(self)
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

    func setDelegateToTextFields(_ delegate: UITextFieldDelegate) {
        phoneNumberField.delegate = delegate
        passwordFieldFirst.delegate = delegate
        passwordFieldSecond.delegate = delegate
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
    }
}

extension RegistrationView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return false }

        let updatedText: String
        if let textRange = Range(range, in: currentText) {
            updatedText = currentText.replacingCharacters(in: textRange, with: string)
        } else {
            updatedText = string
        }
        textField.text = updatedText
        return false
    }
}
