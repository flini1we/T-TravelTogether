import UIKit
import SnapKit

final class TransactionsView: UIView {
    var onCreateTransactionAction: (() -> Void)?
    var onTransactionsTableViewRefresh: (() -> Void)?

    private lazy var screenTitle: UILabel =
        .showTitleLabel(.AppStrings.Transactions.screenTitle, size: .big)

    private(set) lazy var transactionsTableView: UITableView = {
        let table = UITableView()
        let refreshControl = UIRefreshControl()
        refreshControl.addAction(UIAction { [weak self] _ in
            self?.onTransactionsTableViewRefresh?()
            refreshControl.endRefreshing()
        }, for: .valueChanged)
        let bgView: UILabel = .showHeaderLabel(
            .AppStrings.Transactions.emptyTableTitle + "\n\n",
            size: .medium,
            color: .placeholder
        )
        bgView.textAlignment = .center
        bgView.isHidden = false
        bgView.numberOfLines = 0

        table.backgroundView = bgView
        table.refreshControl = refreshControl
        table.separatorStyle = .none
        table.register(
            TransactionTableViewCell.self,
            forCellReuseIdentifier: TransactionTableViewCell.identifier
        )
        table.makeSkeletonable()
        table.showsVerticalScrollIndicator = false
        table.rowHeight = UIElementsValues.tripCellHeight.value
        return table
    }()

    private(set) lazy var addTransactionButton: UIButton = {
        let button = UIButton()
        let buttonTitleImageView = UIImageView(image: SystemImages.addTransactionButtonTitle.image)
        button.addSubview(buttonTitleImageView)
        button.backgroundColor = .primaryYellow
        button.addShadow(
            opacity: 0.25,
            radius: 3,
            shouldRasterize: true
        )
        button.snp.makeConstraints { make in
            make.height.width.equalTo(UIElementsValues.memberCollectionViewCell.value)
        }
        buttonTitleImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(PaddingValues.small.value)
        }
        button.layer.cornerRadius = PaddingValues.default.value
        button.addPressAnimation { [weak self] in
            self?.onCreateTransactionAction?()
        }
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TransactionsView {

    func setup() {
        backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }

    func setupSubviews() {
        addSubview(screenTitle)
        addSubview(transactionsTableView)
        addSubview(addTransactionButton)
        bringSubviewToFront(addTransactionButton)
    }

    func setupConstraints() {
        screenTitle.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(PaddingValues.tiny.value)
            make.leading.equalToSuperview().inset(PaddingValues.medium.value)
        }

        addTransactionButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(PaddingValues.default.value)
            make.trailing.equalToSuperview().inset(PaddingValues.big.value)
        }

        transactionsTableView.snp.makeConstraints { make in
            make.top.equalTo(screenTitle.snp.bottom).offset(PaddingValues.semiSmall.value)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}
