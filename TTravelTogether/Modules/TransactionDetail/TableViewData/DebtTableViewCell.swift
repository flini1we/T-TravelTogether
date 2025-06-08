import UIKit

final class DebtTableViewCell: UITableViewCell {

    static var identifier: String {
        "\(self)"
    }

    private lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = PaddingValues.medium.value
        /*view.addShadow(
            color: .label,
            opacity: 0.25,
            offset: CGSize(width: 0, height: 1.5),
            radius: 3,
            shouldRasterize: true
        )*/
        return view
    }()

    private lazy var debtorName: UILabel = {
        LabelBuilder()
            .makeSkeletonable()
            .skeletonLinesCornerRadius(PaddingValues.tiny.value)
            .skeletonTextLineHeight(.relativeToConstraints)
            .text(.AppStrings.WhiteSpaces.m)
            .font(CustomFonts.default(FontValues.medium.value).font)
            .textColor(.label)
            .build()
    }()

    private lazy  var debtorPhoneNumber: UILabel = {
        LabelBuilder()
            .makeSkeletonable()
            .skeletonLinesCornerRadius(PaddingValues.tiny.value)
            .skeletonTextLineHeight(.relativeToConstraints)
            .text(.AppStrings.WhiteSpaces.s)
            .font(CustomFonts.default(FontValues.semiDefault.value).font)
            .textColor(.secondaryLabel)
            .build()
    }()

    private lazy var debtPriceLabel: UILabel = {
        LabelBuilder()
            .makeSkeletonable()
            .skeletonLinesCornerRadius(PaddingValues.tiny.value)
            .skeletonTextLineHeight(.relativeToConstraints)
            .font(CustomFonts.medium(FontValues.medium.value).font)
            .text(.AppStrings.WhiteSpaces.l)
            .textColor(.label)
            .build()
    }()

    private lazy var statusIndicator: UIView = {
        let view = UIView()
        view.snp.makeConstraints { make in
            make.width.height.equalTo(8)
        }
        view.layer.cornerRadius = 4
        return view
    }()

    private lazy var debtorPriceIndicatorStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            statusIndicator,
            debtPriceLabel
        ])
        stack.spacing = PaddingValues.tiny.value
        stack.alignment = .center
        return stack
    }()

    private lazy var debtorPhoneNameStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            debtorName,
            debtorPhoneNumber
        ])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = PaddingValues.tiny.value
        return stack
    }()

    private lazy var debtData: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            debtorPhoneNameStack,
            debtorPriceIndicatorStack
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

    func setupWithDebt(_ debt: UserTransactionDetailDTO, isCurrentUser: Bool) {
        debtorName.text = debt.firstName + " " + debt.lastName
        bgView.backgroundColor = isCurrentUser ? .primaryBlue.withAlphaComponent(0.1) : .systemBackground
        debtPriceLabel.text = AppFormatter.shared.getValidNumberFromPrice(from: debt.shareAmount) + " \(Currency.ruble.rawValue)"
        debtorPhoneNumber.text = RussianValidationService.shared.validate(phone: debt.phoneNumber)
        statusIndicator.backgroundColor = debt.isRepaid ? .systemGreen : .primaryRed
        
    }
}

private extension DebtTableViewCell {

    func setup() {
        selectionStyle = .none
        setupSubviews()
        setupContraints()
    }

    func setupSubviews() {
        contentView.addSubview(bgView)
        bgView.addSubview(debtData)
    }

    func setupContraints() {
        bgView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }

        debtData.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(PaddingValues.small.value)
            make.top.bottom.equalToSuperview().inset(PaddingValues.small.value)
        }
    }
}
