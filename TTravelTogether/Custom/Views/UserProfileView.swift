import UIKit
import SnapKit

final class UserProfileView: UIView {
    private enum Constants {
        static let profileImageSize = UIScreen.main.bounds.width / 6
    }

    private lazy var userNameLabel: UILabel = {
        LabelBuilder()
            .font(CustomFonts.bold(FontValues.medium.value).font)
            .makeSkeletonable()
            .skeletonTextLineHeight(.relativeToFont)
            .skeletonLinesCornerRadius(PaddingValues.tiny.value)
            .textColor(.label)
            .text(.AppStrings.Profile.namePlaceholder)
            .build()
    }()

    private lazy var userPhoneNumber: UILabel = {
        LabelBuilder()
            .font(CustomFonts.default(FontValues.default.value).font)
            .makeSkeletonable()
            .skeletonTextLineHeight(.relativeToFont)
            .skeletonLinesCornerRadius(PaddingValues.tiny.value)
            .makeSkeletonable()
            .skeletonTextLineHeight(.relativeToFont)
            .skeletonLinesCornerRadius(PaddingValues.tiny.value)
            .textColor(.secondaryLabel)
            .text(.AppStrings.Profile.phonePlaceholder)
            .build()
    }()

    private lazy var editProfileButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.setImage(SystemImages.editTrip.image, for: .normal)
        return button
    }()

    private lazy var userAvatarImage: UIImageView = {
        let image = UIImageView(image: SystemImages.profileDefault.image)
        
        image.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.profileImageSize)
        }
        image.makeSkeletonable()
        image.skeletonCornerRadius = Float(Constants.profileImageSize / 2)
        image.tintColor = .secondaryLabel
        return image
    }()

    private lazy var userDataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            userNameLabel,
            userPhoneNumber
        ])
        stack.makeSkeletonable()
        stack.spacing = PaddingValues.small.value
        stack.axis = .vertical
        stack.alignment = .leading
        return stack
    }()

    private lazy var userAvatarDataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            userAvatarImage,
            userDataStackView
        ])
        stack.makeSkeletonable()
        stack.spacing = PaddingValues.default.value
        stack.alignment = .center
        return stack
    }()

    private lazy var dataStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            userAvatarDataStackView,
            editProfileButton
        ])
        stack.makeSkeletonable()
        stack.spacing = PaddingValues.medium.value
        stack.alignment = .center
        return stack
    }()

    func setupWithUser(user: User) {
        userAvatarImage.image = SystemImages.profileDefault.image
        userNameLabel.text = user.name + " " + user.lastName
        userPhoneNumber.text = RussianValidationService.shared.validate(phone: user.phoneNumber)
    }

    init(isEditable: Bool, shoulDecendTextSize: Bool) {
        super.init(frame: .zero)
        editProfileButton.isHidden = !isEditable
        if shoulDecendTextSize {
            userNameLabel.font = CustomFonts.default(FontValues.semiDefault.value).font
            userPhoneNumber.font = CustomFonts.default(FontValues.default.value).font
            userAvatarImage.skeletonCornerRadius = Float(Constants.profileImageSize * 0.8 / 2)
            userAvatarImage.snp.remakeConstraints { make in
                make.width.height.equalTo(Constants.profileImageSize * 0.8)
            }
        }
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension UserProfileView {

    func setup() {
        makeSkeletonable()
        setupSubviews()
        setupConstraints()
    }

    func setupSubviews() {

        addSubview(dataStack)
    }

    func setupConstraints() {

        dataStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
