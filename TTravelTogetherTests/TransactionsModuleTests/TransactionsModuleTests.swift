import XCTest
@testable import TTravelTogether
import Combine

final class TransactionsViewModelTests: XCTestCase {
    var viewModel: TransactionsViewModel!
    var networkService: MockNetworkService!
    var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        networkService = MockNetworkService()
    }

    override func tearDown() {
        viewModel = nil
        networkService = nil
        cancellables.removeAll()
        super.tearDown()
    }

    // MARK: - loadData Tests

    func testLoadData_WhenSuccess_ShouldUpdateTransactionsAndStopLoading() {
        // Arrange
        let travelId = 123
        let transactionDTO = TransactionDTO(
            id: 1,
            description: "Test Transaction",
            totalCost: 100.0,
            category: "Food",
            createdAt: Date(),
            participants: []
        )
        let transactionsDTO = [transactionDTO]

        networkService.getTransactionsResult = .success(transactionsDTO)

        let expectation = XCTestExpectation(description: "Transactions updated")

        viewModel = TransactionsViewModel(networkService: networkService)
        viewModel.travelId = travelId

        // Act
        viewModel.loadData()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.transactions.count, 1)
            XCTAssertEqual(self.viewModel.transactions[0].id, transactionDTO.id)
            XCTAssertFalse(self.viewModel.isLoadingData)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadData_WhenFailure_ShouldTriggerOnErrorDidAppear() {
        // Arrange
        let travelId = 123
        let error = CustomError.hiddenError("Network error")
        networkService.getTransactionsResult = .failure(error)

        var receivedError: CustomError?
        let expectation = XCTestExpectation(description: "Error triggered on failure")

        viewModel = TransactionsViewModel(networkService: networkService)
        viewModel.travelId = travelId
        viewModel.onErrorDidAppear = { err in
            receivedError = err
            expectation.fulfill()
        }

        // Act
        viewModel.loadData()

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(receivedError?.localizedDescription, error.localizedDescription)
    }

    // MARK: - getTransactionId Tests

    func testGetTransactionId_WithValidIndex_ShouldReturnCorrectId() {
        // Arrange
        let transaction = Transaction(id: 456, description: "Another", price: 50.0, category: "Other", createdAt: Date(), participants: [])
        viewModel = TransactionsViewModel(networkService: networkService)
        viewModel.transactions = [transaction]

        // Act
        let result = viewModel.getTransactionId(at: IndexPath(row: 0, section: 0))

        // Assert
        XCTAssertEqual(result, transaction.id)
    }

    func testGetTransactionId_WithInvalidIndex_ShouldNotCrash() {
        // Arrange
        viewModel = TransactionsViewModel(networkService: networkService)
        viewModel.transactions = []

        // Act
        let result = viewModel.getTransactionId(at: IndexPath(row: 0, section: 0))

        // Assert
        XCTAssertEqual(result, -1) // Предполагаем, что по умолчанию возвращается -1
    }
}

// MARK: - Mock Network Service

class MockNetworkService: INetworkService {
    var getTransactionsResult: Result<[TransactionDTO], CustomError>?

    // MARK: - getTransactions
    func getTransactions(tripId: Int, completion: @escaping ((Result<[TransactionDTO], CustomError>) -> Void)) {
        if let result = getTransactionsResult {
            completion(result)
        }
    }

    // MARK: - Unused Methods (Stubbed)

    func register(user: UserDTO, completion: @escaping (Result<String, CustomError>) -> Void) {}
    func login(userData: LoginUserDataType, completion: @escaping ((Result<LoginUserDataType, CustomError>) -> Void) {}
    func createTrip(tripDetail: CreateTripDTO, completion: @escaping ((Result<CreateTripDTO, CustomError>) -> Void) {}
    func getActiveTrips(completion: @escaping ((Result<[TripDTO], CustomError>) -> Void) {}
    func getTripDetail(id: Int, completion: @escaping ((Result<TripDetailDTO, CustomError>) -> Void) {}
    func updateTrip(tripDetail: EditTripDTO, completion: @escaping ((Result<EditTripDTO, CustomError>) -> Void) {}
    func leaveTrip(with id: Int, completion: @escaping ((Result<Void, CustomError>) -> Void) {}
    func getUserProfile(completion: @escaping ((Result<User, CustomError>) -> Void) {}
    func createTransaction(travelId: Int, createdTransaction: CreatedTransactionDTO, completion: @escaping ((Result<Void, CustomError>) -> Void) {}
    func getTransactionDetail(transactionId id: Int, completion: @escaping ((Result<TransactionDetailDTO, CustomError>) -> Void) {}
    func updateTransaction(transactionDetailDTO: TransactionDetailDTO, completion: @escaping ((Result<Void, CustomError>) -> Void) {}
    func deleteTransaction(id: Int, completion: @escaping ((Result<Void, CustomError>) -> Void) {}
}
