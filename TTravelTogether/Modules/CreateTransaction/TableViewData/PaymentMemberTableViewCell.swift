import UIKit

final class PaymentMemberTableViewCell: UITableViewCell {

    static var identifier: String {
        "\(self)"
    }

    private lazy var memberFirstName: UILabel = {
        LabelBuilder()
            .font(CustomFonts.medium(FontValues.semiDefault.value).font)
            .textColor(.label)
            .build()
    }()

    private lazy var memberLastName: UILabel = {
        LabelBuilder()
            .font(CustomFonts.medium(FontValues.semiDefault.value).font)
            .textColor(.label)
            .build()
    }()

    private lazy var memberInfo: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            memberFirstName,
            memberLastName
        ])
        stack.spacing = PaddingValues.small.value
        return stack
    }()

    private lazy var memberPhoneTitle: UILabel = {
        LabelBuilder()
            .textColor(.placeholder)
            .font(CustomFonts.default(FontValues.default.value).font)
            .build()
    }()

    private lazy var memberData: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            memberInfo,
            memberPhoneTitle
        ])
        stack.spacing = PaddingValues.tiny.value
        stack.axis = .vertical
        stack.alignment = .leading
        return stack
    }()

    private(set) lazy var priceTextField: UITextField = {
        TextFieldBuilder()
            .font(CustomFonts.default(FontValues.small.value).font)
            .cornerRadius(.default)
            .placeHolder(Currency.ruble.rawValue)
            .keyboardType(.numberPad)
            .padding(PaddingValues.tiny.value)
            .textAlignment(.center)
            .build()
    }()

    private lazy var dataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            memberData,
            priceTextField
        ])
        stack.spacing = PaddingValues.medium.value
        stack.alignment = .center
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupWithUser(_ user: UserPayable) {
        memberFirstName.text = user.name
        memberLastName.text = user.lastName
        memberPhoneTitle.text = RussianValidationService.shared.validate(phone: user.phoneNumber)
        priceTextField.text = user.price.description
        priceTextField.isUserInteractionEnabled = user.isPriceEditable
    }
}

private extension PaymentMemberTableViewCell {

    func setup() {
        selectionStyle = .none
        setupSubviews()
        setupConstraints()
    }

    func setupSubviews() {
        contentView.addSubview(dataStackView)
    }

    func setupConstraints() {
        dataStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(PaddingValues.default.value)
            make.top.bottom.equalToSuperview().inset(PaddingValues.default.value)
        }

        priceTextField.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(4)
            make.height.equalToSuperview().multipliedBy(0.8)
        }
    }
}
