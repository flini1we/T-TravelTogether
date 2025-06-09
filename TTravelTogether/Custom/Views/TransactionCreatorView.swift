import UIKit

final class TransactionCreatorView: UIView {

    private lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = PaddingValues.medium.value
        view.addShadow(
            opacity: 0.25,
            offset: CGSize(width: 0, height: 1.5),
            radius: 3,
            shouldRasterize: true
        )
        view.makeSkeletonable()
        return view
    }()

    private lazy var viewTitle: UILabel = {
        LabelBuilder()
            .text(.AppStrings.Transactions.Detail.creatorTitle)
            .textColor(.label)
            .font(CustomFonts.medium(FontValues.semiMedium.value).font)
            .makeSkeletonable()
            .skeletonLinesCornerRadius(PaddingValues.tiny.value)
            .skeletonTextLineHeight(.relativeToFont)
            .build()
    }()

    private lazy var creatorData: UserProfileView = {
        UserProfileView(isEditable: false, shoulDecendTextSize: true)
    }()

    private lazy var creatorInfo: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            viewTitle,
            creatorData
        ])
        stack.spacing = PaddingValues.default.value
        stack.axis = .vertical
        stack.alignment = .leading
        stack.makeSkeletonable()
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupWithUser(_ user: User) {
        creatorData.setupWithUser(user: user)
    }
}

private extension TransactionCreatorView {

    func setup() {
        makeSkeletonable()
        setupSubviews()
        setupConstraints()
    }

    func setupSubviews() {
        addSubview(bgView)
        bgView.addSubview(creatorInfo)
    }

    func setupConstraints() {
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        creatorInfo.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(PaddingValues.small.value)
        }
    }
}
