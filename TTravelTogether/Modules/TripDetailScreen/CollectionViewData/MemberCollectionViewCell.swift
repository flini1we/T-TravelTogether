import UIKit
import SnapKit
import SkeletonView

final class MemberCollectionViewCell: UICollectionViewCell {

    static var identifier: String {
        "\(self)"
    }

    private lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = PaddingValues.medium.value
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        view.layer.shadowRadius = 3
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.borderColor = UIColor.primaryBlue.cgColor
        makeSkeletonable()
        return view
    }()

    private lazy var phoneNumberTitle: UILabel = {
        LabelBuilder()
            .font(CustomFonts.default(FontValues.default.value).font)
            .textColor(.label)
            .build()
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupWithUser(_ user: User, at indexPath: IndexPath) {
        phoneNumberTitle.text = RussianValidationService.shared.validate(phone: user.phoneNumber)
        bgView.layer.borderWidth = (indexPath.row == 0) ? 1 : 0
    }
}

private extension MemberCollectionViewCell {

    func setup() {
        contentView.makeSkeletonable()
        setupSubviews()
        setupConstraints()
    }

    func setupSubviews() {
        contentView.addSubview(bgView)
        bgView.addSubview(phoneNumberTitle)
    }

    func setupConstraints() {
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(PaddingValues.tiny.value)
        }

        phoneNumberTitle.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }
}
