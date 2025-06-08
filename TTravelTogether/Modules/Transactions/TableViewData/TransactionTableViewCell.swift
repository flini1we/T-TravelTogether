import UIKit
import SnapKit

final class TransactionTableViewCell: UITableViewCell {

    static var identifier: String {
        "\(self)"
    }
    private var currentTransaction: Transaction?

    private(set) lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = PaddingValues.medium.value
        view.addShadow(
            color: .label,
            opacity: 0.25,
            offset: CGSize(width: 0, height: 1.5),
            radius: 3,
            shouldRasterize: true
        )
        view.makeSkeletonable()
        return view
    }()

    private lazy var transactionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(UIElementsValues.transactionCategoryItem.value)
        }
        imageView.makeSkeletonable()
        imageView.skeletonCornerRadius = Float(UIElementsValues.transactionCategoryItem.value / 2)
        return imageView
    }()

    private lazy var transactionTitle: UILabel = {
        LabelBuilder()
            .font(CustomFonts.medium(FontValues.medium.value).font)
            .text(.AppStrings.WhiteSpaces.l)
            .textColor(.label)
            .makeSkeletonable()
            .skeletonTextLineHeight(.relativeToFont)
            .skeletonLinesCornerRadius(PaddingValues.tiny.value)
            .build()
    }()

    private lazy var transactionDescription: UILabel = {
        LabelBuilder()
            .font(CustomFonts.default(FontValues.semiDefault.value).font)
            .text(.AppStrings.WhiteSpaces.xl)
            .textColor(.secondaryLabel)
            .makeSkeletonable()
            .skeletonTextLineHeight(.relativeToFont)
            .skeletonLinesCornerRadius(PaddingValues.tiny.value)
            .build()
    }()

    private lazy var transactionPrice: UILabel = {
        LabelBuilder()
            .font(CustomFonts.medium(FontValues.default.value).font)
            .text(.AppStrings.WhiteSpaces.l)
            .textColor(.primaryBlue)
            .makeSkeletonable()
            .skeletonTextLineHeight(.relativeToFont)
            .skeletonLinesCornerRadius(PaddingValues.tiny.value)
            .build()
    }()

    private lazy var titleDescriptionStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            transactionTitle,
            transactionDescription
        ])
        stack.axis = .vertical
        stack.makeSkeletonable()
        stack.spacing = PaddingValues.semiSmall.value
        stack.alignment = .leading
        return stack
    }()

    private lazy var imageTitleDescriptionStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            transactionImageView,
            titleDescriptionStackView
        ])
        stack.spacing = PaddingValues.default.value
        stack.makeSkeletonable()
        stack.alignment = .center
        return stack
    }()

    private lazy var transactionDataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            imageTitleDescriptionStackView,
            transactionPrice
        ])
        stack.spacing = PaddingValues.medium.value
        stack.alignment = .center
        stack.makeSkeletonable()
        return stack
    }()

    func setupWithTransaction(_ transaction: Transaction) {
        self.currentTransaction = transaction

        transactionTitle.text = transaction.category.rawValue
        transactionPrice.text = AppFormatter
            .shared
            .getValidNumberFromPrice(from: transaction.price)
            .addCurrency(.ruble)
        transactionDescription.text = transaction.description
        transactionImageView.image = transaction.category.getImage
        transactionImageView.tintColor = .primaryYellow
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        transactionImageView.image = nil
    }
}

private extension TransactionTableViewCell {

    func setup() {
        makeSkeletonable()
        selectionStyle =  .none
        setupSubviews()
        setupConstraints()
    }

    func setupSubviews() {
        contentView.addSubview(bgView)
        bgView.addSubview(transactionDataStackView)
    }

    func setupConstraints() {
        transactionPrice.setContentCompressionResistancePriority(.required, for: .horizontal)

        bgView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(PaddingValues.small.value)
            make.leading.trailing.equalToSuperview().inset(PaddingValues.default.value)
        }

        transactionDataStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(PaddingValues.default.value)
            make.top.bottom.equalToSuperview().inset(PaddingValues.small.value)
        }
    }
}
