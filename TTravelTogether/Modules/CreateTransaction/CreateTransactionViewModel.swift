import Combine
import Foundation

protocol ICreateTransactionViewModel {
    var isLoading: Bool { get }
    var isLoadinPublisher: Published<Bool>.Publisher { get }

    var selectedPaymentOption: PaymentOption? { get set }
    var onErrorDidAppear: ((CustomError) -> Void)? { get set }
    var onOptionUpdate: (([UserPayable], PaymentOption) -> Void)? { get set }
    var onPriceCapturing: (() -> Double?)? { get set }
    var onTransactionCreating: (() -> Void)? { get set }
    var onTransactionEditing: (() -> Void)? { get set }
    var isEditingMode: Bool { get set }

    func createTransaction(description: String, price: String, categoty: TransactionCategory)
    func deleteOldTransaction(id: Int)
    func updatePaymentOption()
    func validateTransaction(
        description: String,
        price: String
    ) -> (isValid: Bool, description: String)
    func updatePayablePrice(user: UserPayable, price: Double)
    func calculatePaymentOption(_ transaction: TransactionDetail) -> PaymentOption
    func convertTransactionMembers(members: [UserTransactionDetailDTO]) -> [UserPayable]
}

final class CreateTransactionViewModel: ICreateTransactionViewModel {

    private var networkService: INetworkService
    private var travelId: Int
    private var currentTrip: TripDetailDTO?
    private var payableUsers: [UserPayable] = []
    var isEditingMode = false

    @Published var isLoading: Bool = false
    var isLoadinPublisher: Published<Bool>.Publisher { $isLoading }

    var onErrorDidAppear: ((CustomError) -> Void)?
    var onOptionUpdate: (([UserPayable], PaymentOption) -> Void)?
    var onPriceCapturing: (() -> Double?)?
    var onTransactionCreating: (() -> Void)?
    var onTransactionEditing: (() -> Void)?

    var selectedPaymentOption: PaymentOption? {
        didSet {
            let group = DispatchGroup()
            if currentTrip == nil {
                group.enter()
                getTrip { [weak self] result in
                    switch result {
                    case .success(let tripDetailDto):
                        self?.currentTrip = tripDetailDto
                    case .failure(let error):
                        self?.onErrorDidAppear?(error)
                    }
                    self?.isLoading = false
                    group.leave()
                }
            }
            group.notify(queue: DispatchQueue.main) { [weak self] in
                guard let self else { return }
                guard let currentTrip, let selectedPaymentOption else { return }
                guard let devidedPrice = onPriceCapturing?() else { return }
                payableUsers = createPayableUsers(
                    trip: currentTrip,
                    option: selectedPaymentOption,
                    price: devidedPrice
                )
                onOptionUpdate?(payableUsers, selectedPaymentOption)
            }
        }
    }

    init(networkService: INetworkService, travelId: Int) {
        self.networkService = networkService
        self.travelId = travelId
    }

    func createTransaction(description: String, price: String, categoty: TransactionCategory) {
        guard let price = Double(price) else {
            onErrorDidAppear?(.hiddenError(.AppStrings.Transactions.Errors.priceInvalid))
            return
        }
        networkService.createTransaction(
            travelId: travelId,
            createdTransaction: CreatedTransactionDTO(
                price: price,
                description: description,
                createdAt: AppFormatter.shared.getStringRepresentationOfDateISO8601(.now),
                category: categoty.camelValue,
                participants: UserPayable.wrapToCreatedTransactionMemberDTO(payableUsers)
            )
        ) { [weak self] result in
            switch result {
            case .success(_):
                self?.onTransactionCreating?()
            case .failure(let error):
                self?.onErrorDidAppear?(error)
            }
        }
    }

    func deleteOldTransaction(id: Int) {
        networkService.deleteTransaction(id: id) { [weak self] result in
            switch result {
            case .success(_):
                self?.onTransactionEditing?()
            case .failure(let error):
                self?.onErrorDidAppear?(.hiddenError(error.localizedDescription))
            }
        }
    }

    func updatePaymentOption() {
        if currentTrip != nil {
            let selectedPaymentOption = selectedPaymentOption
            self.selectedPaymentOption = selectedPaymentOption
        }
    }

    func validateTransaction(
        description: String,
        price: String
    ) -> (isValid: Bool, description: String) {
        if description.isEmpty {
            return (false, .AppStrings.Transactions.Errors.emptyDescription)
        }
        let totalAmount = payableUsers.map {
            $0.price
        }.reduce(0.0, +)
        guard let price = Double(price) else {
            return (false, .AppStrings.Transactions.Errors.priceInvalid)
        }
        if selectedPaymentOption == .split && totalAmount != price {
            return (false, .AppStrings.Transactions.Errors.missingPrice)
        }
        return (true, "")
    }

    func updatePayablePrice(user: UserPayable, price: Double) {
        payableUsers = payableUsers.map {
            return !RussianValidationService.shared.compareTwoPhones($0.phoneNumber, user.phoneNumber)
            ? $0
            : UserPayable(
                name: $0.name,
                lastName: $0.lastName,
                phoneNumber: $0.phoneNumber,
                price: price,
                isPriceEditable: $0.isPriceEditable
            )
        }
    }

    func calculatePaymentOption(_ transaction: TransactionDetail) -> PaymentOption {
        if transaction.participants.count == 1 {
            return .forAll
        } else if Set(transaction.participants.compactMap({
            let debt = $0.shareAmount
            return debt != 0 ? debt : nil
        })).count == 1 {
            return .forAll
        } else { return .split }
    }

    func convertTransactionMembers(members: [UserTransactionDetailDTO]) -> [UserPayable] {
        members.map {
            UserPayable(
                name: $0.firstName,
                lastName: $0.lastName,
                phoneNumber: $0.phoneNumber,
                price: $0.shareAmount,
                isPriceEditable: true
            )
        }
    }
}

private extension CreateTransactionViewModel {

    func getTrip(completion: @escaping ((Result<TripDetailDTO, CustomError>) -> Void)) {
        isLoading = true
        networkService.getTripDetail(id: travelId) { result in
            switch result {
            case .success(let tripDetailDto):
                completion(.success(tripDetailDto))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func createPayableUsers(trip: TripDetailDTO, option: PaymentOption, price: Double) -> [UserPayable] {
        let allParticipants = [trip.admin] + trip.members
        let participantsCount = Double(trip.members.count + 1)
        switch option {
        case .forYour:
            return [trip.admin].map {
                createUserPayable(from: $0, price: price)
            }
        case .forAll:
            return allParticipants.map {
                createUserPayable(from: $0, price: price / participantsCount)
            }
        case .split:
            return allParticipants.map {
                createUserPayable(from: $0, price: 0)
            }
        }
    }

    func createUserPayable(from user: User, price: Double) -> UserPayable {
       UserPayable(
           name: user.name,
           lastName: user.lastName,
           phoneNumber: user.phoneNumber,
           price: price,
           isPriceEditable: selectedPaymentOption == .split
       )
   }
}
