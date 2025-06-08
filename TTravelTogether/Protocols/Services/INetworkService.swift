import Foundation

protocol INetworkService {

    func register(
        user: UserDTO,
        completion: @escaping (Result<String, CustomError>) -> Void
    )
    func login(
        userData: LoginUserDataType,
        completion: @escaping ((Result<LoginUserDataType, CustomError>) -> Void)
    )
    func createTrip(
        tripDetail: CreateTripDTO,
        completion: @escaping ((Result<CreateTripDTO, CustomError>) -> Void)
    )
    func getActiveTrips(
        completion: @escaping ((Result<[TripDTO], CustomError>) -> Void)
    )
    func getTripDetail(
        id: Int,
        completion: @escaping ((Result<TripDetailDTO, CustomError>) -> Void)
    )
    func updateTrip(
        tripDetail: EditTripDTO,
        completion: @escaping ((Result<EditTripDTO, CustomError>) -> Void)
    )
    func leaveTrip(
        with id: Int,
        completion: @escaping ((Result<Void, CustomError>) -> Void)
    )
    func getUserProfile(
        completion: @escaping ((Result<User, CustomError>) -> Void)
    )
    func getTransactions(
        tripId: Int,
        completion: @escaping ((Result<[TransactionDTO], CustomError>) -> Void)
    )
    func createTransaction(
        travelId: Int,
        createdTransaction: CreatedTransactionDTO,
        completion: @escaping ((Result<Void, CustomError>) -> Void)
    )
    func getTransactionDetail(
        transactionId id: Int,
        completion: @escaping ((Result<TransactionDetailDTO, CustomError>) -> Void)
    )
    func updateTransaction(
        transactionDetailDTO: TransactionDetailDTO,
        completion: @escaping ((Result<Void, CustomError>) -> Void)
    )
    func deleteTransaction(
        id: Int,
        completion: @escaping ((Result<Void, CustomError>) -> Void)
    )
    func remindDebtors(
        transactionId: Int,
        completion: @escaping ((Result<Void, CustomError>) -> Void)
    )
}
