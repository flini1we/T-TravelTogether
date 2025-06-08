import XCTest
@testable import TTravelTogether
import Combine

final class TransactionDetailViewModelTests: XCTestCase {
    var viewModel: TransactionDetailViewModel!
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

    func testLoadData_WhenSuccess_ShouldUpdateTransactionDetail() {
        // Arrange
        let transactionId = 123
        let travelId = 456

        let creator = User(phoneNumber: "+79123456789", name: "Ivan", lastName: "Petrov")
        let participant = UserTransactionDetailDTO(
            firstName: "Anna",
            lastName: "Sidorova",
            phoneNumber: "+79999999999",
            shareAmount: 100,
            isRepaid: false
        )

        let dto = TransactionDetailDTO(
            id: transactionId,
            price: 100.0,
            description: "Dinner",
            category: "Food",
            participants: [participant],
            creator: creator,
            createdAt: Date()
        )

        networkService.getTransactionDetailResult = .success(dto)

        let expectation = XCTestExpectation(description: "Transaction detail updated")

        viewModel = TransactionDetailViewModel(networkService: networkService, transactionId: transactionId, travelId: travelId)
        viewModel.transactionDetailPublisher
            .dropFirst()
            .sink { transaction in
                XCTAssertNotNil(transaction)
                XCTAssertEqual(transaction?.id, transactionId)
                XCTAssertEqual(transaction?.price, 100.0)
                XCTAssertEqual(transaction?.description, "Dinner")
                XCTAssertEqual(transaction?.participants.count, 1)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2.0)
    }

    func testLoadData_WhenFailure_ShouldTriggerOnErrorDidAppear() {
        // Arrange
        let transactionId = 123
        let travelId = 456
        let error = CustomError.hiddenError("Network error")
        networkService.getTransactionDetailResult = .failure(error)

        var receivedError: CustomError?
        let expectation = XCTestExpectation(description: "Error triggered on load failure")

        viewModel = TransactionDetailViewModel(networkService: networkService, transactionId: transactionId, travelId: travelId)
        viewModel.onErrorDidAppear = { err in
            receivedError = err
            expectation.fulfill()
        }

        viewModel.loadData()

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(receivedError?.localizedDescription, error.localizedDescription)
    }

    // MARK: - updateTransactionDetailDebts Tests

    func testUpdateTransactionDetailDebts_WithValidUser_ShouldMarkAsRepaid() {
        // Arrange
        let user = User(phoneNumber: "+79123456789", name: "Ivan", lastName: "Petrov")
        let participant = UserTransactionDetailDTO(
            firstName: "Anna",
            lastName: "Sidorova",
            phoneNumber: "+79123456789",
            shareAmount: 100,
            isRepaid: false
        )

        let transactionDetail = TransactionDetail(
            id: 1,
            price: 100,
            description: "Test",
            category: "Other",
            participants: [participant],
            creator: user,
            createdAt: Date()
        )

        viewModel = TransactionDetailViewModel(networkService: networkService, transactionId: 1, travelId: 1)
        viewModel.transactionDetail = transactionDetail

        // Act
        viewModel.updateTransactionDetailDebts(debtorPhoneNumber: "+79123456789")

        // Assert
        guard let updated = viewModel.transactionDetail else {
            XCTFail("Transaction detail should not be nil")
            return
        }

        let updatedParticipant = updated.participants.first { $0.phoneNumber == "+79123456789" }
        XCTAssertNotNil(updatedParticipant)
        XCTAssertTrue(updatedParticipant?.isRepaid ?? false)
    }

    // MARK: - currentUserPayedAlready Tests

    func testCurrentUserPayedAlready_WhenPaid_ShouldReturnTrue() {
        // Arrange
        let user = User(phoneNumber: "+79123456789", name: "Ivan", lastName: "Petrov")
        let participant = UserTransactionDetailDTO(
            firstName: "Anna",
            lastName: "Sidorova",
            phoneNumber: "+79123456789",
            shareAmount: 0,
            isRepaid: true
        )

        let transactionDetail = TransactionDetail(
            id: 1,
            price: 100,
            description: "Test",
            category: "Other",
            participants: [participant],
            creator: user,
            createdAt: Date()
        )

        viewModel = TransactionDetailViewModel(networkService: networkService, transactionId: 1, travelId: 1)
        viewModel.transactionDetail = transactionDetail

        // Act
        let result = viewModel.currentUserPayedAlready(user: user, transaction: transactionDetail)

        // Assert
        XCTAssertTrue(result)
    }

    func testCurrentUserPayedAlready_WhenNotPaid_ShouldReturnFalse() {
        // Arrange
        let user = User(phoneNumber: "+79123456789", name: "Ivan", lastName: "Petrov")
        let participant = UserTransactionDetailDTO(
            firstName: "Anna",
            lastName: "Sidorova",
            phoneNumber: "+79123456789",
            shareAmount: 100,
            isRepaid: false
        )

        let transactionDetail = TransactionDetail(
            id: 1,
            price: 100,
            description: "Test",
            category: "Other",
            participants: [participant],
            creator: user,
            createdAt: Date()
        )

        viewModel = TransactionDetailViewModel(networkService: networkService, transactionId: 1, travelId: 1)
        viewModel.transactionDetail = transactionDetail

        // Act
        let result = viewModel.currentUserPayedAlready(user: user, transaction: transactionDetail)

        // Assert
        XCTAssertFalse(result)
    }

    // MARK: - isCreator Tests

    func testIsCreator_WhenUserIsCreator_ShouldReturnTrue() {
        // Arrange
        let creator = User(phoneNumber: "+79123456789", name: "Ivan", lastName: "Petrov")
        let transactionDetail = TransactionDetail(
            id: 1,
            price: 100,
            description: "Test",
            category: "Other",
            participants: [],
            creator: creator,
            createdAt: Date()
        )

        viewModel = TransactionDetailViewModel(networkService: networkService, transactionId: 1, travelId: 1)
        viewModel.transactionDetail = transactionDetail

        // Act
        let result = viewModel.isCreator(creator)

        // Assert
        XCTAssertTrue(result)
    }

    func testIsCreator_WhenUserIsNotCreator_ShouldReturnFalse() {
        // Arrange
        let creator = User(phoneNumber: "+79123456789", name: "Ivan", lastName: "Petrov")
        let otherUser = User(phoneNumber: "+79999999999", name: "Anna", lastName: "Sidorova")
        let transactionDetail = TransactionDetail(
            id: 1,
            price: 100,
            description: "Test",
            category: "Other",
            participants: [],
            creator: creator,
            createdAt: Date()
        )

        viewModel = TransactionDetailViewModel(networkService: networkService, transactionId: 1, travelId: 1)
        viewModel.transactionDetail = transactionDetail

        // Act
        let result = viewModel.isCreator(otherUser)

        // Assert
        XCTAssertFalse(result)
    }

    // MARK: - deleteTransaction Tests

    func testDeleteTransaction_WhenSuccess_ShouldCallOnTransactionDeleting() {
        // Arrange
        let expectation = XCTestExpectation(description: "onTransactionDeleting called")
        let transactionId = 123

        networkService.deleteTransactionResult = .success(())

        viewModel = TransactionDetailViewModel(networkService: networkService, transactionId: transactionId, travelId: 456)
        viewModel.onTransactionDeleting = {
            expectation.fulfill()
        }

        // Act
        viewModel.deleteTransaction()

        wait(for: [expectation], timeout: 1.0)
    }

    func testDeleteTransaction_WhenFailure_ShouldTriggerOnErrorDidAppear() {
        // Arrange
        let expectation = XCTestExpectation(description: "onErrorDidAppear called on delete failure")
        let transactionId = 123
        let error = CustomError.hiddenError("Network error")

        networkService.deleteTransactionResult = .failure(error)

        viewModel = TransactionDetailViewModel(networkService: networkService, transactionId: transactionId, travelId: 456)
        viewModel.onErrorDidAppear = { err in
            XCTAssertEqual(err.localizedDescription, error.localizedDescription)
            expectation.fulfill()
        }

        // Act
        viewModel.deleteTransaction()

        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - didDebtorsCoveredDebt Tests

    func testDidDebtorsCoveredDebt_WhenAllRepaid_ShouldReturnTrue() {
        // Arrange
        let participant = UserTransactionDetailDTO(
            firstName: "Anna",
            lastName: "Sidorova",
            phoneNumber: "+79123456789",
            shareAmount: 0,
            isRepaid: true
        )

        let transactionDetail = TransactionDetail(
            id: 1,
            price: 100,
            description: "Test",
            category: "Other",
            participants: [participant],
            creator: User(phoneNumber: "+71234567890", name: "Admin", lastName: "User"),
            createdAt: Date()
        )

        viewModel = TransactionDetailViewModel(networkService: networkService, transactionId: 1, travelId: 1)
        viewModel.transactionDetail = transactionDetail

        // Act
        let result = viewModel.didDebtorsCoveredDebt()

        // Assert
        XCTAssertTrue(result)
    }

    func testDidDebtorsCoveredDebt_WhenNoTransaction_ShouldTriggerErrorAndReturnFalse() {
        // Arrange
        var receivedError: CustomError?
        let expectation = XCTestExpectation(description: "onErrorDidAppear triggered for no transaction")

        viewModel = TransactionDetailViewModel(networkService: networkService, transactionId: 1, travelId: 1)
        viewModel.onErrorDidAppear = { err in
            receivedError = err
            expectation.fulfill()
        }

        // Act
        let result = viewModel.didDebtorsCoveredDebt()

        // Assert
        XCTAssertFalse(result)
        XCTAssertEqual(receivedError?.localizedDescription, .AppStrings.Transactions.Detail.noTransaction)
        wait(for: [expectation], timeout: 1.0)
    }
}

// MARK: - Mock Network Service

class MockNetworkService: INetworkService {
    var getTransactionDetailResult: Result<TransactionDetailDTO, CustomError>?
    var deleteTransactionResult: Result<Void, CustomError>?
    var updateTransactionResult: Result<Void, CustomError>?

    // MARK: - getTransactionDetail
    func getTransactionDetail(transactionId id: Int, completion: @escaping ((Result<TransactionDetailDTO, CustomError>) -> Void)) {
        if let result = getTransactionDetailResult {
            completion(result)
        }
    }

    // MARK: - deleteTransaction
    func deleteTransaction(id: Int, completion: @escaping ((Result<Void, CustomError>) -> Void)) {
        if let result = deleteTransactionResult {
            completion(result)
        }
    }

    // MARK: - updateTransaction
    func updateTransaction(transactionDetailDTO: TransactionDetailDTO, completion: @escaping ((Result<Void, CustomError>) -> Void)) {
        if let result = updateTransactionResult {
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
    func getTransactions(tripId: Int, completion: @escaping ((Result<[TransactionDTO], CustomError>) -> Void) {}
    func createTransaction(travelId: Int, createdTransaction: CreatedTransactionDTO, completion: @escaping ((Result<Void, CustomError>) -> Void) {}
}
