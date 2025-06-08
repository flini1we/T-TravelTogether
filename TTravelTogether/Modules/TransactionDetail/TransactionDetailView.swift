import UIKit

final class TransactionDetailView: UIView {
    var onPayingDebtOrNotificateMembers: ((Bool) -> Void)?

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.makeSkeletonable()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()

    private lazy var transactionCategory: UILabel = {
        LabelBuilder()
            .makeSkeletonable()
            .skeletonLinesCornerRadius(PaddingValues.tiny.value)
            .skeletonTextLineHeight(.relativeToFont)
            .font(CustomFonts.medium(FontValues.title.value).font)
            .text(.AppStrings.WhiteSpaces.m)
            .textColor(.primaryYellow)
            .build()
    }()

    private lazy var transactionDescription: UILabel = {
        LabelBuilder()
            .makeSkeletonable()
            .skeletonLinesCornerRadius(PaddingValues.tiny.value)
            .skeletonTextLineHeight(.relativeToFont)
            .text(.AppStrings.WhiteSpaces.xl)
            .textColor(.secondaryLabel)
            .font(CustomFonts.default(FontValues.medium.value).font)
            .build()
    }()

    private lazy var transactionDescriptionCategoryStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            transactionCategory,
            transactionDescription
        ])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = PaddingValues.small.value
        stack.makeSkeletonable()
        return stack
    }()

    private lazy var transactionPrice: UILabel = {
        LabelBuilder()
            .makeSkeletonable()
            .skeletonLinesCornerRadius(PaddingValues.tiny.value)
            .skeletonTextLineHeight(.relativeToFont)
            .text(.AppStrings.WhiteSpaces.m)
            .textColor(.primaryBlue)
            .font(CustomFonts.medium(FontValues.medium.value).font)
            .build()
    }()

    private lazy var transactionDescriptionCategoryPriceStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            transactionDescriptionCategoryStack,
            transactionPrice
        ])
        stack.spacing = PaddingValues.big.value
        stack.alignment = .center
        stack.makeSkeletonable()
        return stack
    }()

    private lazy var leadingSeparator: UIView = {
        generateSeparator()
    }()

    private lazy var debtsTitle: UILabel = {
        LabelBuilder()
            .text(.AppStrings.Transactions.Detail.debtTitle)
            .textColor(.label)
            .font(CustomFonts.medium(FontValues.big.value).font)
            .build()
    }()

    private(set) lazy var debtTalbleView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.rowHeight = UIElementsValues.debtCell.value
        table.isScrollEnabled = false
        table.register(DebtTableViewCell.self, forCellReuseIdentifier: DebtTableViewCell.identifier)
        return table
    }()

    private lazy var creatorView: TransactionCreatorView = {
        TransactionCreatorView()
    }()

    private lazy var debtDataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            debtsTitle,
            debtTalbleView
        ])
        stack.axis = .vertical
        stack.spacing = PaddingValues.tiny.value
        return stack
    }()

    private lazy var transactionDataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            transactionDescriptionCategoryPriceStack,
            creatorView,
            debtDataStackView
        ])
        stack.axis = .vertical
        stack.spacing = PaddingValues.big.value
        stack.makeSkeletonable()
        return stack
    }()

    private lazy var payDebtButton: UIButton = {
        ButtonBuilder()
            .backgroundColor(.primaryYellow)
            .cornerRadius(.default)
            .tintColor(.buttonLabel)
            .font(CustomFonts.bold(FontValues.default.value).font)
            .build()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupWithTransaction(_ transaction: TransactionDetail, currentUser: User, payedAlready: Bool) {
        transactionCategory.text = transaction.category.rawValue
        transactionDescription.text = transaction.description
        transactionPrice.text = AppFormatter.shared.getValidNumberFromPrice(from: transaction.price) + " \(Currency.ruble.rawValue)"
        creatorView.setupWithUser(transaction.creator)

        let isUserCreator = RussianValidationService.shared.compareTwoPhones(
            currentUser.phoneNumber,
            transaction.creator.phoneNumber
        )
        payDebtButton.setTitle(
            isUserCreator
            ? .AppStrings.Transactions.Detail.notificateDebtors
            : .AppStrings.Transactions.Detail.payDebt
        , for: .normal)
        payDebtButton.addPressAnimation { [weak self] in
            self?.onPayingDebtOrNotificateMembers?(isUserCreator)
        }
        payDebtButton.changeActivision(!payedAlready)
    }

    func updateTableHeight(data: [UserTransactionDetailDTO]) {
        UIView.animate(withDuration: 0.3) {
            self.debtTalbleView.snp.remakeConstraints { make in
                make.height.equalTo(Int(UIElementsValues.debtCell.value) * data.count)
            }
            self.transactionDataStackView.addArrangedSubview(self.payDebtButton)
            self.layoutIfNeeded()
        }
    }
}

private extension TransactionDetailView {

    func generateSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = .secondaryLabel
        view.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        return view
    }

    func setup() {
        makeSkeletonable()
        backgroundColor = .systemBackground
        setupSubviews()
        setupContraints()
    }

    func setupSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(transactionDataStackView)
    }

    func setupContraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }

        transactionDataStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(PaddingValues.default.value)
            make.width.equalToSuperview().offset(-PaddingValues.default.value * 2)
            make.bottom.equalToSuperview()
        }
    }
}
