import UIKit

final class ProfileTableViewCell: UITableViewCell {

    static var identifier: String {
        "\(self)"
    }

    private lazy var cellTitle: UILabel = {
        LabelBuilder()
            .font(CustomFonts.default(FontValues.default.value).font)
            .textColor(.label)
            .build()
    }()

    private lazy var cellImageView: UIImageView = {
        let image = UIImageView()
        image.snp.makeConstraints { make in
            make.width.height.equalTo(UIElementsValues.profileCellsIcon.value)
        }
        image.tintColor = .label
        return image
    }()

    private lazy var themeSwitch: UISwitch = {
        let themeSwitch = UISwitch()
        themeSwitch.onTintColor = .primaryYellow
        themeSwitch.isOn = ThemeManager.current == .dark
        themeSwitch.addAction(UIAction { _ in
            ThemeManager.current = themeSwitch.isOn ? .dark : .light
        }, for: .touchUpInside)
        return themeSwitch
    }()

    private lazy var dataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            cellImageView,
            cellTitle
        ])
        stack.spacing = PaddingValues.default.value
        stack.alignment = .center
        return stack
    }()

    func setupWithData(_ data: ProfileScreenCellTypes) {
        if data == .switchTheme { selectionStyle = .none }
        switch data {
        case .archive:
            setupArchive()
        case .changeLanguage:
            setupChangeLanguage()
        case .switchTheme:
            setupSwitchTheme()
        case .leave:
            setupLeave()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ProfileTableViewCell {

    func setup() {
        setupSubviews()
        setupConstraints()
    }

    func setupSubviews() {

        contentView.addSubview(dataStackView)
    }

    func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.height.equalTo(UIElementsValues.profileCellsHeight.value)
        }

        dataStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(PaddingValues.default.value)
        }
    }

    func setupArchive() {
        cellTitle.text = .AppStrings.Profile.archiveTitle
        cellImageView.image = SystemImages.archiveTrips.image
    }

    func setupChangeLanguage() {
        cellTitle.text = .AppStrings.Profile.changeLanguageTitle
        cellImageView.image = SystemImages.changeLanguage.image
    }

    func setupSwitchTheme() {
        cellTitle.text = .AppStrings.Profile.changeThemeTitle
        cellImageView.image = SystemImages.changeTheme.image

        addSubview(themeSwitch)
        themeSwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(PaddingValues.default.value)
        }
    }

    func setupLeave() {
        cellTitle.text = .AppStrings.Profile.leaveTitle
        cellImageView.image = SystemImages.leaveTrip.image
        cellImageView.tintColor = .primaryRed
    }
}
