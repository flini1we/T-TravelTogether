import UIKit
import SnapKit

final class RegistrationView: UIView, IRegistrationView {

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private lazy var contentView: UIView = { UIView() }()

    private lazy var imageLabel: UIImageView = {
        let imageView = UIImageView(image: .registrationLogo)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private(set) lazy var registerViewTitle: UILabel = {
        LabelBuilder()
            .font(CustomFonts.bold(FontValues.medium.value).font)
            .textColor(.label)
            .text(.AppStrings.Auth.registerTitle)
            .build()
    }()

    private(set) lazy var userNameField: UITextField = {
        TextFieldBuilder()
            .font(.systemFont(ofSize: FontValues.default.value))
            .cornerRadius(.default)
            .isSecureEntry(false)
            .placeHolder(.AppStrings.Auth.userNameFieldPlaceholder)
            .returnKeyType(.continue)
            .paddinLeft(PaddingValues.default.value)
            .delegate(self)
            .build()
    }()

    private(set) lazy var userNameHint: UILabel = {
        LabelBuilder()
            .font(CustomFonts.default(FontValues.small.value).font)
            .textColor(.primaryRed)
            .build()
    }()

    private(set) lazy var userLastNameField: UITextField = {
        TextFieldBuilder()
            .font(.systemFont(ofSize: FontValues.default.value))
            .cornerRadius(.default)
            .isSecureEntry(false)
            .placeHolder(.AppStrings.Auth.userLastNameFieldPlaceholder)
            .returnKeyType(.continue)
            .paddinLeft(PaddingValues.default.value)
            .delegate(self)
            .build()
    }()

    private(set) lazy var userLastNameHint: UILabel = {
        LabelBuilder()
            .font(CustomFonts.default(FontValues.small.value).font)
            .textColor(.primaryRed)
            .build()
    }()

    private(set) lazy var phoneNumberField: UITextField = {
        TextFieldBuilder()
            .font(.systemFont(ofSize: FontValues.default.value))
            .cornerRadius(.default)
            .isSecureEntry(false)
            .keyboardType(.phonePad)
            .placeHolder(.AppStrings.Auth.phoneNumber)
            .returnKeyType(.continue)
            .paddinLeft(PaddingValues.default.value)
            .delegate(self)
            .build()
    }()

    private(set) lazy var phoneNumberFieldHint: UILabel = {
        LabelBuilder()
            .font(CustomFonts.default(FontValues.small.value).font)
            .textColor(.primaryRed)
            .build()
    }()

    private(set) lazy var passwordFieldFirst: UITextField = {
        TextFieldBuilder()
            .font(.systemFont(ofSize: FontValues.default.value))
            .cornerRadius(.default)
            .isSecureEntry(true)
            .placeHolder(.AppStrings.Auth.password)
            .returnKeyType(.continue)
            .paddinLeft(PaddingValues.default.value)
            .enableTogglingSecure()
            .delegate(self)
            .build()
    }()

    private(set) lazy var passwordFieldHint: UILabel = {
        LabelBuilder()
            .font(CustomFonts.default(FontValues.small.value).font)
            .textColor(.primaryRed)
            .build()
    }()

    private(set) lazy var passwordFieldConfirmed: UITextField = {
        TextFieldBuilder()
            .font(.systemFont(ofSize: FontValues.default.value))
            .cornerRadius(.default)
            .isSecureEntry(true)
            .placeHolder(.AppStrings.Auth.confirmPassword)
            .returnKeyType(.done)
            .paddinLeft(PaddingValues.default.value)
            .enableTogglingSecure()
            .delegate(self)
            .build()
    }()

    private(set) lazy var passwordFieldConfirmedHint: UILabel = {
        LabelBuilder()
            .font(CustomFonts.default(FontValues.small.value).font)
            .textColor(.primaryRed)
            .build()
    }()

    private lazy var registerButton: UIButton = {
        ButtonBuilder()
            .tintColor(.buttonLabel)
            .backgroundColor(.primaryYellow)
            .title(.AppStrings.Auth.registerAction)
            .cornerRadius(.default)
            .font(CustomFonts.bold(FontValues.default.value).font)
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

    private lazy var textFieldsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            userNameField,
            userNameHint,
            userLastNameField,
            userLastNameHint,
            phoneNumberField,
            phoneNumberFieldHint,
            passwordFieldFirst,
            passwordFieldHint,
            passwordFieldConfirmed,
            passwordFieldConfirmedHint
        ])
        stack.axis = .vertical
        stack.spacing = PaddingValues.small.value
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
        (phoneNumberField.text ?? "", passwordFieldFirst.text ?? "", passwordFieldConfirmed.text ?? "")
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

    func onKeyboardWillShow(frame: CGRect) {
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset

        if let activeField = findFirstResponder() as? UITextField {
            let rect = activeField.convert(activeField.bounds, to: scrollView)
            scrollView.scrollRectToVisible(rect, animated: true)
        }
    }

    func onKeyboardWillHide() {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
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
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageLabel)
        contentView.addSubview(textFieldsStackView)
        addSubview(registerButton)
        addSubview(transparentBG)
        addSubview(activityIndicator)
    }

    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }

        imageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(contentView.snp.top).inset(PaddingValues.default.value)
            make.height.equalTo(UIScreen.main.bounds.width / 2.75)
        }

        textFieldsStackView.snp.makeConstraints { make in
            make.top.equalTo(imageLabel.snp.bottom).offset(PaddingValues.semiBig.value)
            make.leading.trailing.equalToSuperview().inset(PaddingValues.medium.value)
            make.bottom.equalToSuperview()
        }

        registerButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(PaddingValues.default.value)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(PaddingValues.medium.value)
        }

        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(UIElementsValues.activiryIndicator.value)
        }

        transparentBG.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func findFirstResponder() -> UIView? {
        for view in textFieldsStackView.arrangedSubviews where view.isFirstResponder { return view }
        return nil
    }
}

extension RegistrationView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case userNameField:
            userLastNameField.becomeFirstResponder()
        case userLastNameField:
            phoneNumberField.becomeFirstResponder()
        case phoneNumberField:
            passwordFieldFirst.becomeFirstResponder()
        case passwordFieldFirst:
            passwordFieldConfirmed.becomeFirstResponder()
        case passwordFieldConfirmed:
            passwordFieldConfirmed.resignFirstResponder()
        default:
            return true
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField == phoneNumberField
        ? formatPhoneNumberForPhoneFields(textField: textField, range: range, replacementString: string)
        : textField.isSecureTextEntry
        ? secureFieldShouldChangeCharactersIn(textField: textField, range: range, replacementString: string)
        : true
    }
}
