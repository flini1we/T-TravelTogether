import Foundation
import UserNotifications

protocol ITransactionDetailViewModel {
    var onErrorDidAppear: ((CustomError) -> Void)? { get set }
    var onTransactionDeleting: (() -> Void)? { get set }

    var travelId: Int { get }
    var isLoadingData: Bool { get }
    var isLoadingDataPublisher: Published<Bool>.Publisher { get }

    var transactionDetail: TransactionDetail? { get }
    var transactionDetailPublisher: Published<TransactionDetail?>.Publisher { get }

    func loadData()
    func updateTransactionDetailDebts(debtorPhoneNumber: String)
    func currentUserPayedAlready(user: User, transaction: TransactionDetail) -> Bool
    func isCreator(_ user: User) -> Bool
    func deleteTransaction()
    func didDebtorsCoveredDebt() -> Bool
    func remindDebtors(completion: @escaping (Result<Void, CustomError>) -> Void)
    func presentNotification(request: UNNotificationRequest)
}

final class TransactionDetailViewModel: ITransactionDetailViewModel {

    private let networkService: INetworkService
    private let notificationCenter: IPushNotificationCenter
    private let transactionId: Int
    let travelId: Int

    var onErrorDidAppear: ((CustomError) -> Void)?
    var onTransactionDeleting: (() -> Void)?

    @Published var isLoadingData: Bool = false
    var isLoadingDataPublisher: Published<Bool>.Publisher {
        $isLoadingData
    }
    @Published var transactionDetail: TransactionDetail?
    var transactionDetailPublisher: Published<TransactionDetail?>.Publisher {
        $transactionDetail
    }

    init(
        networkService: INetworkService,
        notificationCenter: IPushNotificationCenter,
        transactionId: Int,
        travelId: Int
    ) {
        self.networkService = networkService
        self.notificationCenter = notificationCenter
        self.transactionId = transactionId
        self.travelId = travelId
    }

    func loadData() {
        isLoadingData = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            networkService.getTransactionDetail(transactionId: transactionId) { [weak self] result in
                switch result {
                case .success(let transactionDetailDTO):
                    self?.isLoadingData = false
                    self?.transactionDetail = transactionDetailDTO.wrapToTransactionDetail()
                case .failure(let error):
                    self?.onErrorDidAppear?(error)
                }
            }
        }
    }

    func updateTransactionDetailDebts(debtorPhoneNumber: String) {
        guard let transactionDetail else {
            onErrorDidAppear?(.hiddenError("позже придумаю и вынесу"))
            return
        }
        let updatedDebtors = transactionDetail.participants.map {
            return $0.phoneNumber == debtorPhoneNumber && !$0.isRepaid
            ? UserTransactionDetailDTO(
                firstName: $0.firstName,
                lastName: $0.lastName,
                phoneNumber: debtorPhoneNumber,
                shareAmount: 0,
                isRepaid: true
            )
            : $0
        }
        let updatedTransactinoDetail = TransactionDetail(
            id: transactionDetail.id,
            price: transactionDetail.price,
            description: transactionDetail.description,
            category: transactionDetail.category,
            participants: updatedDebtors,
            creator: transactionDetail.creator,
            createdAt: transactionDetail.createdAt
        )
        self.transactionDetail = updatedTransactinoDetail
        let transactionDetailDTO = updatedTransactinoDetail.wrapToDTO()
        networkService.updateTransaction(transactionDetailDTO: transactionDetailDTO) { result in
            print(result)
        }
    }

    func currentUserPayedAlready(user: User, transaction: TransactionDetail) -> Bool {
        if transaction.participants.count == 1 { return true }
        for participant in transaction.participants
        where RussianValidationService.shared.compareTwoPhones(
            participant.phoneNumber,
            user.phoneNumber
        ) {
            return participant.isRepaid
        }
        return false
    }

    func isCreator(_ user: User) -> Bool {
        guard let transactionDetail else { return false }
        return RussianValidationService.shared.compareTwoPhones(
            user.phoneNumber,
            transactionDetail.creator.phoneNumber
        )
    }

    func deleteTransaction() {
        networkService.deleteTransaction(id: transactionId) { result in
            switch result {
            case .success(_):
                self.onTransactionDeleting?()
            case .failure(let error):
                self.onErrorDidAppear?(error)
            }
        }
    }

    func didDebtorsCoveredDebt() -> Bool {
        guard let transactionDetail else {
            onErrorDidAppear?(.hiddenError(.AppStrings.Transactions.Detail.noTransaction))
            return false
        }
        return transactionDetail.participants.map {
            $0.isRepaid
        }.contains(true)
    }

    func remindDebtors(completion: @escaping (Result<Void, CustomError>) -> Void) {
        if #available(iOS 16, *) {
            Task {
                do {
                    let granted = try await notificationCenter.registerForNotification()
                    if granted {
                        networkService.remindDebtors(transactionId: transactionId) { result in
                            switch result {
                            case .success(_):
                                completion(.success(()))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    } else {
                        completion(.failure(.hiddenError(.AppStrings.Notification.grantedForNotifications)))
                    }
                } catch {
                    // TODO: handle
                }
            }
        } else {
            // TODO: todo
        }
    }

    func presentNotification(request: UNNotificationRequest) {
        notificationCenter.showNotification(for: request) { result in
            switch result {
            case .failure(let error):
                self.onErrorDidAppear?(error)
            default:
                break
            }
        }
    }
}
