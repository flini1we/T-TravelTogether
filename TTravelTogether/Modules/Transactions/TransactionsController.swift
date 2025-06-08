import UIKit
import Combine

final class TransactionsController: UIViewController {
    var coordinator: IMainCoordinator?

    private var transactionView: TransactionsView {
        view as! TransactionsView
    }

    private(set) var viewModel: ITransactionsViewModel
    private var transactionsTableViewDelegate: TransactionsTableViewDelegate?
    private var transactionsTableViewDataSource: TransactionsTableViewDataSource?
    private var cancellables: Set<AnyCancellable> = []

    override func loadView() {
        super.loadView()
        view = TransactionsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
    }

    init(viewModel: ITransactionsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setId(_ id: Int) {
        viewModel.travelId = id
    }
}

private extension TransactionsController {

    func setup() {
        transactionView.transactionsTableView.makeSkeletonable()
        setupData()
        setupBindings()
    }

    func setupData() {
        transactionsTableViewDelegate = TransactionsTableViewDelegate()
        transactionsTableViewDelegate?.onTransactionSelection = { [weak self] indexPath in
            guard let self else { return }
            let transactionId = viewModel.getTransactionId(at: indexPath)
            coordinator?.showTransactionDetailScreen(
                transactionId: transactionId,
                travelId: viewModel.travelId
            )
        }
        transactionsTableViewDataSource = TransactionsTableViewDataSource(
            data: viewModel.transactions,
            table: transactionView.transactionsTableView
        )
        transactionView.transactionsTableView.delegate = transactionsTableViewDelegate
        transactionView.transactionsTableView.dataSource = transactionsTableViewDataSource
    }

    func setupBindings() {
        viewModel.onErrorDidAppear = { [weak self] error in
            self?.present(AlertFactory.createErrorAlert(message: error.localizedDescription), animated: true)
        }

        viewModel
            .transactionsPublisher
            .dropFirst()
            .sink { [weak self] transactions in
                self?.transactionsTableViewDataSource?.updateData(transactions)
                self?.transactionView.transactionsTableView.backgroundView?.isHidden = !transactions.isEmpty
            }
            .store(in: &cancellables)

        viewModel
            .isLoadingDataPublisher
            .dropFirst()
            .sink { [weak self] isLoading in
                _ = isLoading
                ? self?.transactionView.transactionsTableView.showSkeleton()
                : self?.transactionView.transactionsTableView.hideSkeleton()
            }
            .store(in: &cancellables)

        viewModel
            .isLoadingDataPublisher
            .dropFirst()
            .map { !$0 }
            .assign(to: \.isEnabled, on: transactionView.addTransactionButton)
            .store(in: &cancellables)

        viewModel
            .isLoadingDataPublisher
            .dropFirst()
            .map { !$0 }
            .assign(to: \.isEnabled, on: transactionView.addTransactionButton)
            .store(in: &cancellables)

        viewModel.isLoadingDataPublisher
            .map { $0 ? 0.75 : 1.0 }
            .sink { [weak self] alpha in
                self?.transactionView.addTransactionButton.alpha = alpha
            }
            .store(in: &cancellables)

        transactionView.onCreateTransactionAction = { [weak self] in
            guard let self else { return }
            coordinator?.showCreateTransactionScreen(travelId: viewModel.travelId)
        }

        transactionView.onTransactionsTableViewRefresh = { [weak self] in
            self?.viewModel.loadData()
        }
    }
}
