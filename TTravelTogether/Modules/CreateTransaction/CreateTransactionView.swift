import UIKit

final class CreateTransactionView: UIView {
    var onSegmentValueDidChange: ((PaymentOption) -> Void)?
    var onTransactionCreate: (() -> Void)?

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()

    private lazy var transactionCategoryTitleHint: UILabel = {
        LabelBuilder()
            .font(CustomFonts.default(FontValues.semiDefault.value).font)
            .textColor(.secondaryLabel)
            .text(.AppStrings.Transactions.selectedCategoryHint)
            .build()
    }()

    private(set) lazy var transactionCategoryTitle: UILabel = {
        LabelBuilder()
            .font(CustomFonts.medium(FontValues.title.value).font)
            .textColor(.label)
            .text(TransactionCategory.other.rawValue)
            .build()
    }()

    private lazy var menuButton: UIButton = {
        let button = UIButton()
        button.setImage(SystemImages.menu(false).image, for: .normal)
        button.tintColor = .primaryYellow
        let menu = UIMenu(title: "", children:
            TransactionCategory.allCases.map { category in
                UIAction(title: category.rawValue) { [weak self] _ in
                    UIView.transition(
                        with: self?.transactionCategoryTitle ?? UIView(),
                        duration: 0.3,
                        options: .transitionCrossDissolve,
                        animations: { self?.transactionCategoryTitle.text = category.rawValue },
                        completion: nil
                    )
                }
            }
        )
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
        return button
    }()

    private lazy var titleAndMenuButtonStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            transactionCategoryTitle,
            menuButton
        ])
        stack.spacing = PaddingValues.medium.value
        stack.alignment = .center
        return stack
    }()

    private lazy var transactionCategoryTitles: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleAndMenuButtonStackView,
            transactionCategoryTitleHint
        ])
        stack.axis = .vertical
        stack.spacing = PaddingValues.tiny.value
        return stack
    }()

    private lazy var descriptionTextField: UITextField = {
        TextFieldBuilder()
            .font(.systemFont(ofSize: FontValues.default.value))
            .cornerRadius(.default)
            .placeHolder(.AppStrings.Transactions.descriptionTextFieldPlaceholder)
            .returnKeyType(.continue)
            .paddinLeft(PaddingValues.default.value)
            .delegate(self)
            .build()
    }()

    private lazy var descriptionStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            descriptionTextField,
            priceTextField
        ])
        stack.axis = .vertical
        stack.spacing = PaddingValues.semiSmall.value
        return stack
    }()

    private(set) lazy var priceTextField: UITextField = {
        TextFieldBuilder()
            .font(.systemFont(ofSize: FontValues.default.value))
            .cornerRadius(.default)
            .placeHolder(.AppStrings.Transactions.priceTextFieldPlaceholder)
            .keyboardType(.numberPad)
            .paddinLeft(PaddingValues.default.value)
            .delegate(self)
            .build()
    }()

    private(set) lazy var paymentOptionTitle: UILabel = {
        LabelBuilder()
            .font(CustomFonts.medium(FontValues.title.value).font)
            .textColor(.label)
            .text(.AppStrings.Transactions.paymentOption)
            .build()
    }()

    private lazy var selectedPaymentOption: UISegmentedControl = {
        let segment = UISegmentedControl()
        let segments = PaymentOption.allCases
        for (index, paymentOption) in segments.enumerated() {
            let image = paymentOption.image
                .withConfiguration(UIImage.SymbolConfiguration(
                    pointSize: PaddingValues.big.value,
                    weight: .medium
                )
            )
            segment.insertSegment(with: image, at: index, animated: false)
        }
        segment.setupTinkoffStyle()
        segment.addAction(UIAction { [weak self] _ in
            self?.onSegmentValueDidChange?(PaymentOption.allCases[segment.selectedSegmentIndex])
        }, for: .valueChanged)
        let segmentSize = UIScreen.main.bounds.width * 0.6 / 3
        segment.snp.makeConstraints { make in make.height.equalTo(segmentSize) }
        return segment
    }()

    private lazy var paymentOptionsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            paymentOptionTitle,
            selectedPaymentOption,
            membersTableView
        ])
        stack.axis = .vertical
        stack.spacing = PaddingValues.small.value
        return stack
    }()

    private(set) lazy var membersTableView: UITableView = {
        let table = UITableView()
        table.register(
            PaymentMemberTableViewCell.self,
            forCellReuseIdentifier: PaymentMemberTableViewCell.identifier
        )
        table.separatorStyle = .none
        table.rowHeight = 75
        table.isScrollEnabled = false
        table.showsVerticalScrollIndicator = false
        return table
    }()

    private lazy var createTransactionButton: UIButton = {
        let button = ButtonBuilder()
            .backgroundColor(.primaryYellow)
            .cornerRadius(.default)
            .tintColor(.buttonLabel)
            .title(.AppStrings.Transactions.createTransactionButtonTitle)
            .font(CustomFonts.bold(FontValues.default.value).font)
            .build()
        button.addPressAnimation { [weak self] in
            self?.onTransactionCreate?()
        }
        return button
    }()

    private lazy var dataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            transactionCategoryTitles,
            descriptionStackView,
            paymentOptionsStack,
            createTransactionButton
        ])
        stack.axis = .vertical
        stack.spacing = PaddingValues.semiBig.value
        return stack
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
        view.alpha = 0
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func onLoadingUpdate(isLoading: Bool) {
        transparentBG.alpha = isLoading ? 1 : 0
        activityIndicator.alpha = isLoading ? 1 : 0
    }

    func updateTableData(_ users: [UserPayable]) {
        UIView.animate(withDuration: 0.3) {
            self.membersTableView.snp.updateConstraints { make in
                make.height.equalTo(users.count * 75)
            }
            self.layoutIfNeeded()
        }
    }

    func getTranscationData() -> (description: String, price: String, categoty: TransactionCategory) {
        (descriptionTextField.textSafe, priceTextField.textSafe, transactionCategoryTitle.text!.eraseToCategory())
    }

    func setupWithEditedTransaction(_ transaction: TransactionDetail, paymentOption: PaymentOption) {
        transactionCategoryTitle.text = transaction.category.rawValue
        descriptionTextField.text = transaction.description
        priceTextField.text = transaction.price.description
        selectedPaymentOption.selectedSegmentIndex = paymentOption.rawValue
        createTransactionButton.setTitle(
            .AppStrings.Transactions.Create.updateButtonTitle,
            for: .normal
        )
    }
}

extension CreateTransactionView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case descriptionTextField:
            priceTextField.becomeFirstResponder()
        case priceTextField:
            self.endEditing(true)
        default:
            return true
        }
        return true
    }
}

private extension CreateTransactionView {

    func setup() {
        setupDismiss()
        setupSubviews()
        setupConstraints()
    }

    func setupSubviews() {
        backgroundColor = .systemBackground
        addSubview(scrollView)
        scrollView.addSubview(dataStackView)
        addSubview(transparentBG)
        addSubview(activityIndicator)
    }

    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }

        dataStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(PaddingValues.medium.value)
            make.width.equalToSuperview().offset(-PaddingValues.medium.value * 2)
            make.bottom.equalToSuperview()
        }

        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(UIElementsValues.activiryIndicator.value)
        }

        transparentBG.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
