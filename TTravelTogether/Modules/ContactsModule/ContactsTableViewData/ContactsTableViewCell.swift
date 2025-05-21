import UIKit

final class ContactsTableViewCell: UITableViewCell {

    static var identifier: String {
        "\(self)"
    }

    private lazy var contactFirstName: UILabel = {
        LabelBuilder()
            .font(CustomFonts.default(FontValues.default.value).font)
            .textColor(.label)
            .build()
    }()

    private lazy var contactLastName: UILabel = {
        LabelBuilder()
            .font(CustomFonts.bold(FontValues.default.value).font)
            .textColor(.label)
            .build()
    }()

    private lazy var contactInfo: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            contactFirstName,
            contactLastName
        ])
        stack.spacing = PaddingValues.small.value
        return stack
    }()

    private lazy var contactPhoneTitle: UILabel = {
        LabelBuilder()
            .textColor(.placeholder)
            .font(CustomFonts.default(FontValues.small.value).font)
            .build()
    }()

    private lazy var contactSelectionIndicator: UIImageView = {
        UIImageView(image: SystemImages.circle(false).image)
    }()

    private lazy var userSpecialInfoStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            contactPhoneTitle,
            contactSelectionIndicator
        ])
        stack.spacing = PaddingValues.default.value
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    func setupWithUser(_ contact: Contact, alreadySelected: Bool) {
        contactPhoneTitle.text = contact.phoneNumber
        contactFirstName.text = contact.firstName
        contactLastName.text = contact.secondName
        updateSelectionState(isSelected: alreadySelected)
    }

    func updateSelectionState(isSelected: Bool) {
        contactSelectionIndicator.image = SystemImages.circle(isSelected).image
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ContactsTableViewCell {

    func setup() {
        setupSubviews()
        setupConstraints()
    }

    func setupSubviews() {
        contentView.addSubview(contactInfo)
        contentView.addSubview(userSpecialInfoStackView)
    }

    func setupConstraints() {
        contactInfo.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(PaddingValues.default.value)
            make.centerY.equalToSuperview()
        }

        userSpecialInfoStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(PaddingValues.default.value)
            make.centerY.equalToSuperview()
        }
    }
}
