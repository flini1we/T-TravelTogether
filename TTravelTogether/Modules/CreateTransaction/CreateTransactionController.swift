import UIKit
import Combine

final class CreateTransactionController: UIViewController {

    private var createTransactionView: CreateTransactionView {
        view as! CreateTransactionView
    }
    private var viewModel: ICreateTransactionViewModel
    private var cancellables: Set<AnyCancellable> = []
    private var paymentMembersDataSource: PaymentMembersDataSource?
    var onTransactionCreating: (() -> Void)?
    var onTransactionEdited: (() -> Void)?
    private var editedTransaction: TransactionDetail?

    init(viewModel: ICreateTransactionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view = CreateTransactionView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setupEditingMode(_ transaction: TransactionDetail) {
        viewModel.isEditingMode = true
        let paymentOption = viewModel.calculatePaymentOption(transaction)
        viewModel.selectedPaymentOption = paymentOption
        createTransactionView.setupWithEditedTransaction(transaction, paymentOption: paymentOption)
        editedTransaction = transaction
    }
}

private extension CreateTransactionController {

    func setup() {
        setupBindings()
        setupDataSource()
    }

    func setupBindings() {
        createTransactionView.onTransactionCreate = { [weak self] in
            guard let self else { return }
            let transactionData = createTransactionView.getTranscationData()
            let validationResult = viewModel.validateTransaction(
                description: transactionData.description,
                price: transactionData.price
            )
            guard validationResult.isValid else {
                present(AlertFactory.createErrorAlert(message: validationResult.description), animated: true)
                return
            }
            viewModel.createTransaction(
                description: transactionData.description,
                price: transactionData.price,
                categoty: transactionData.categoty
            )
            if viewModel.isEditingMode {
                guard let editedTransaction else { return }
                viewModel.deleteOldTransaction(id: editedTransaction.id)
            }
        }

        createTransactionView
            .priceTextField
            .textPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                viewModel.updatePaymentOption()
            }
            .store(in: &cancellables)

        viewModel.onPriceCapturing = { [weak self] in
            guard let self else { return nil }
            guard let price = Double(createTransactionView.priceTextField.text!) else { return nil }
            return price
        }

        createTransactionView.onSegmentValueDidChange = { [weak self] paymentOption in
            self?.viewModel.selectedPaymentOption = paymentOption
        }

        viewModel.onErrorDidAppear = { [weak self] error in
            self?.present(AlertFactory.createErrorAlert(message: error.localizedDescription), animated: true)
        }

        viewModel.onOptionUpdate = { [weak self] members, option in
            self?.createTransactionView.updateTableData(members)
            self?.paymentMembersDataSource?.updateData(data: members)
        }

        viewModel.isLoadinPublisher
            .dropFirst()
            .sink { [weak self] isLoading in
                self?.createTransactionView.onLoadingUpdate(isLoading: isLoading)
            }
            .store(in: &cancellables)

        viewModel.onTransactionCreating = { [weak self] in
            self?.onTransactionCreating?()
        }

        viewModel.onTransactionEditing = { [weak self] in
            self?.onTransactionEdited?()
        }
    }

    func setupDataSource() {
        paymentMembersDataSource = PaymentMembersDataSource()
        paymentMembersDataSource?.onPriceUpdate = { [weak self] user, price in
            self?.viewModel.updatePayablePrice(user: user, price: price)
        }
        paymentMembersDataSource?.setupDataSource(with: [], tableView: createTransactionView.membersTableView)
    }
}
