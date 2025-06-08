import UIKit
import Combine

final class TransactionDetailController: UIViewController {
    private var transactionDetailView: TransactionDetailView {
        view as! TransactionDetailView
    }
    var coordinator: IMainCoordinator?
    private var currentUser: User

    private var viewModel: ITransactionDetailViewModel
    private var cancellables: Set<AnyCancellable> = []
    private var debtDataSource: DebtTableViewDataSource?

    var onTransactionDeleting: (() -> Void)?

    override func loadView() {
        super.loadView()
        view = TransactionDetailView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
    }

    init(viewModel: ITransactionDetailViewModel, currentUser: User) {
        self.viewModel = viewModel
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TransactionDetailController {

    func setup() {
        setupBindings()
        setupDataSource()
        setupNavigationItem()
    }

    func setupBindings() {
        viewModel
            .isLoadingDataPublisher
            .dropFirst()
            .sink { [weak self] isLoading in
                guard let self else { return }
                _ = isLoading
                ? transactionDetailView.showSkeleton()
                : transactionDetailView.hideSkeleton()
            }
            .store(in: &cancellables)

        viewModel
            .transactionDetailPublisher
            .sink { [weak self] transactionDetail in
                guard let self, let transactionDetail else { return }
                let transactionParticipants = transactionDetail.participants.filter {
                    $0.phoneNumber != transactionDetail.creator.phoneNumber
                }
                let payerdAlready = viewModel.currentUserPayedAlready(
                    user: currentUser,
                    transaction: transactionDetail
                )
                transactionDetailView.setupWithTransaction(transactionDetail, currentUser: currentUser, payedAlready: payerdAlready)
                debtDataSource?.updateData(data: transactionParticipants)
                transactionDetailView.updateTableHeight(data: transactionParticipants)
                navigationItem.rightBarButtonItems?.forEach {
                    $0.setEnabled(true, enableColor: $0.tag == 1 ? .primaryRed : nil)
                }
            }
            .store(in: &cancellables)

        viewModel.onTransactionDeleting = { [weak self] in
            self?.onTransactionDeleting?()
        }

        transactionDetailView.onPayingDebtOrNotificateMembers = { [weak self] isCreator in
            guard let self else { return }
            if isCreator {
                viewModel.remindDebtors { result in
                    switch result {
                    case .success(_):
                        self.present(
                            AlertFactory.showDebtNotificationSuccessAlert(),
                            animated: true
                        )
                    case .failure(let error):
                        self.present(
                            AlertFactory.createErrorAlert(message: error.localizedDescription),
                            animated: true
                        )
                    }
                }
            } else {
                viewModel.updateTransactionDetailDebts(debtorPhoneNumber: currentUser.phoneNumber)
            }
        }
    }

    func showSuccessRemidAlert() {
        let notification = UNMutableNotificationContent()
        notification.title = .AppStrings.Alert.successTitle
        notification.body = .AppStrings.Alert.notificateDebtorsMessage
        notification.sound = .defaultRingtone

        let notificationRequest = UNNotificationRequest(
            identifier: .AppStrings.Notification.reminderNotification,
            content: notification,
            trigger: nil
        )
        viewModel.presentNotification(request: notificationRequest)
    }

    func setupDataSource() {
        debtDataSource = DebtTableViewDataSource(currentUser: currentUser)
        debtDataSource?.setupDataSource(with: transactionDetailView.debtTalbleView, data: [])
    }

    func setupNavigationItem() {
        let deleteButton = UIBarButtonItem(
            title: "",
            image: SystemImages.delete.image,
            primaryAction: UIAction { [weak self] _ in
                guard let self else { return }
                present(
                    viewModel.isCreator(currentUser)
                    ? AlertFactory.createConfirmationAlert(
                        title: .AppStrings.Transactions.Detail.confirmDeletingTitle,
                        message: .AppStrings.Transactions.Detail.confirmDelegingMessage,
                        confirmTitle: .AppStrings.Alert.confirm,
                        onConfirm: { self.viewModel.deleteTransaction() },
                        onCancel: { }
                    )
                    : AlertFactory.createErrorAlert(message: .AppStrings.Transactions.Detail.deletingAdminRequired),
                    animated: true
                )
            },
            menu: nil
        )
        deleteButton.setEnabled(false)
        deleteButton.tag = 1

        let editButton = UIBarButtonItem(
            title: "",
            image: SystemImages.editTrip.image,
            primaryAction: UIAction { [weak self] _ in
                guard let self else { return }
                if !viewModel.isCreator(currentUser) {
                    present(
                        AlertFactory.createErrorAlert(message: .AppStrings.Transactions.Detail.editingAdminRequired),
                        animated: true
                    )
                } else {
                    guard !viewModel.didDebtorsCoveredDebt() else {
                        present(
                            AlertFactory.showTransactionEditingNotAllowedAlert(),
                            animated: true
                        )
                        return
                    }
                    guard let transactionDetail = viewModel.transactionDetail else { return }
                    coordinator?.showEditTransactionScreen(
                        transaction: transactionDetail,
                        travelId: viewModel.travelId
                    )
                }
            },
            menu: nil
        )
        editButton.setEnabled(false)
        editButton.tag = 0

        navigationItem.rightBarButtonItems = [deleteButton, editButton]
    }
}
