import XCTest
@testable import TTravelTogether
import Combine

final class CreateTransactionViewModelTests: XCTestCase {
    var viewModel: CreateTransactionViewModel!
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

    // MARK: - createTransaction Tests

    func testCreateTransaction_WithValidData_ShouldCallOnTransactionCreating() {
        // Arrange
        let expectation = XCTestExpectation(description: "onTransactionCreating called")
        let tripId = 123
        let price = "100.0"
        let description = "Test transaction"
        let category = TransactionCategory.food

        networkService.createTransactionResult = .success(())

        viewModel = CreateTransactionViewModel(networkService: networkService, travelId: tripId)
        viewModel.onTransactionCreating = {
            expectation.fulfill()
        }

        // Act
        viewModel.createTransaction(description: description, price: price, categoty: category)

        wait(for: [expectation], timeout: 1.0)
    }

    func testCreateTransaction_WithInvalidPrice_ShouldTriggerOnError() {
        // Arrange
        let expectation = XCTestExpectation(description: "onErrorDidAppear triggered with invalid price")
        let tripId = 123
        let price = "abc"
        let description = "Test transaction"
        let category = TransactionCategory.food

        viewModel = CreateTransactionViewModel(networkService: networkService, travelId: tripId)
        viewModel.onErrorDidAppear = { error in
            XCTAssertEqual(error.localizedDescription, .AppStrings.Transactions.Errors.priceInvalid)
            expectation.fulfill()
        }

        // Act
        viewModel.createTransaction(description: description, price: price, categoty: category)

        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - validateTransaction Tests

    func testValidateTransaction_WithEmptyDescription_ShouldReturnFalse() {
        // Arrange
        viewModel = CreateTransactionViewModel(networkService: networkService, travelId: 123)
        viewModel.selectedPaymentOption = .forAll

        // Act
        let result = viewModel.validateTransaction(description: "", price: "100")

        // Assert
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.description, .AppStrings.Transactions.Errors.emptyDescription)
    }

    func testValidateTransaction_SplitOptionAndMismatchedTotal_ShouldReturnFalse() {
        // Arrange
        let user1 = User(phoneNumber: "+79123456789", name: "Ivan", lastName: "Petrov")
        let payableUser = UserPayable(
            name: "Ivan",
            lastName: "Petrov",
            phoneNumber: "+79123456789",
            price: 50,
            isPriceEditable: true
        )
        let tripDetail = TripDetailDTO(
            id: 1,
            title: "Trip",
            price: 100,
            start: "",
            end: "",
            admin: user1,
            members: []
        )

        viewModel = CreateTransactionViewModel(networkService: networkService, travelId: 123)
        viewModel.currentTrip = tripDetail
        viewModel.payableUsers = [payableUser]
        viewModel.selectedPaymentOption = .split

        // Act
        let result = viewModel.validateTransaction(description: "Desc", price: "100")

        // Assert
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.description, .AppStrings.Transactions.Errors.missingPrice)
    }

    // MARK: - updatePayablePrice Tests

    func testUpdatePayablePrice_ShouldUpdateCorrectUserPrice() {
        // Arrange
        let user = User(phoneNumber: "+79123456789", name: "Ivan", lastName: "Petrov")
        let payableUser = UserPayable(
            name: user.name,
            lastName: user.lastName,
            phoneNumber: user.phoneNumber,
            price: 0,
            isPriceEditable: true
        )

        viewModel = CreateTransactionViewModel(networkService: networkService, travelId: 123)
        viewModel.payableUsers = [payableUser]

        let newPrice: Double = 50.0

        // Act
        viewModel.updatePayablePrice(user: payableUser, price: newPrice)

        // Assert
        XCTAssertEqual(viewModel.payableUsers[0].price, newPrice)
    }

    // MARK: - calculatePaymentOption Tests

    func testCalculatePaymentOption_ForSingleParticipant_ShouldReturnForAll() {
        // Arrange
        let transaction = TransactionDetail(
            id: 1,
            title: "Test",
            price: 100,
            startsAt: Date(),
            finishAt: Date(),
            admin: User(phoneNumber: "+79123456789", name: "Admin", lastName: "User"),
            members: []
        )

        viewModel = CreateTransactionViewModel(networkService: networkService, travelId: 123)

        // Act
        let option = viewModel.calculatePaymentOption(transaction)

        // Assert
        XCTAssertEqual(option, .forAll)
    }

    func testCalculatePaymentOption_ForMultipleEqualShares_ShouldReturnForAll() {
        // Arrange
        let member1 = UserTransactionDetailDTO(
            firstName: "A", lastName: "B", phoneNumber: "+79123456789", shareAmount: 50
        )
        let member2 = UserTransactionDetailDTO(
            firstName: "C", lastName: "D", phoneNumber: "+79999999999", shareAmount: 50
        )

        let transaction = TransactionDetail(
            id: 1,
            title: "Test",
            price: 100,
            startsAt: Date(),
            finishAt: Date(),
            admin: User(phoneNumber: "+71234567890", name: "Admin", lastName: "User"),
            members: [member1, member2]
        )

        viewModel = CreateTransactionViewModel(networkService: networkService, travelId: 123)

        // Act
        let option = viewModel.calculatePaymentOption(transaction)

        // Assert
        XCTAssertEqual(option, .forAll)
    }

    func testCalculatePaymentOption_ForDifferentShares_ShouldReturnSplit() {
        // Arrange
        let member1 = UserTransactionDetailDTO(
            firstName: "A", lastName: "B", phoneNumber: "+79123456789", shareAmount: 30
        )
        let member2 = UserTransactionDetailDTO(
            firstName: "C", lastName: "D", phoneNumber: "+79999999999", shareAmount: 70
        )

        let transaction = TransactionDetail(
            id: 1,
            title: "Test",
            price: 100,
            startsAt: Date(),
            finishAt: Date(),
            admin: User(phoneNumber: "+71234567890", name: "Admin", lastName: "User"),
            members: [member1, member2]
        )

        viewModel = CreateTransactionViewModel(networkService: networkService, travelId: 123)

        // Act
        let option = viewModel.calculatePaymentOption(transaction)

        // Assert
        XCTAssertEqual(option, .split)
    }

    // MARK: - convertTransactionMembers Tests

    func testConvertTransactionMembers_ShouldMapToUserPayable() {
        // Arrange
        let dto = UserTransactionDetailDTO(
            firstName: "Ivan", lastName: "Petrov", phoneNumber: "+79123456789", shareAmount: 50
        )

        viewModel = CreateTransactionViewModel(networkService: networkService, travelId: 123)

        // Act
        let users = viewModel.convertTransactionMembers(members: [dto])

        // Assert
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users[0].name, dto.firstName)
        XCTAssertEqual(users[0].lastName, dto.lastName)
        XCTAssertEqual(users[0].phoneNumber, dto.phoneNumber)
        XCTAssertEqual(users[0].price, dto.shareAmount)
    }

    // MARK: - deleteOldTransaction Tests

    func testDeleteOldTransaction_WhenSuccess_ShouldCallOnTransactionEditing() {
        // Arrange
        let expectation = XCTestExpectation(description: "onTransactionEditing called")
        let transactionId = 123

        networkService.deleteTransactionResult = .success(())

        viewModel = CreateTransactionViewModel(networkService: networkService, travelId: 123)
        viewModel.onTransactionEditing = {
            expectation.fulfill()
        }

        // Act
        viewModel.deleteOldTransaction(id: transactionId)

        wait(for: [expectation], timeout: 1.0)
    }

    func testDeleteOldTransaction_WhenFailure_ShouldTriggerOnError() {
        // Arrange
        let expectation = XCTestExpectation(description: "onErrorDidAppear called on delete failure")
        let transactionId = 123
        let error = CustomError.hiddenError("Network error")

        networkService.deleteTransactionResult = .failure(error)

        viewModel = CreateTransactionViewModel(networkService: networkService, travelId: 123)
        viewModel.onErrorDidAppear = { err in
            XCTAssertEqual(err.localizedDescription, error.localizedDescription)
            expectation.fulfill()
        }

        // Act
        viewModel.deleteOldTransaction(id: transactionId)

        wait(for: [expectation], timeout: 1.0)
    }
}

// MARK: - Mock Network Service

class MockNetworkService: INetworkService {
    var createTransactionResult: Result<Void, CustomError>?
    var deleteTransactionResult: Result<Void, CustomError>?

    // MARK: - createTransaction
    func createTransaction(
        travelId: Int,
        createdTransaction: CreatedTransactionDTO,
        completion: @escaping ((Result<Void, CustomError>) -> Void)
    ) {
        if let result = createTransactionResult {
            completion(result)
        }
    }

    // MARK: - deleteTransaction
    func deleteTransaction(id: Int, completion: @escaping ((Result<Void, CustomError>) -> Void)) {
        if let result = deleteTransactionResult {
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
    func getTransactionDetail(transactionId id: Int, completion: @escaping ((Result<TransactionDetailDTO, CustomError>) -> Void) {}
    func updateTransaction(transactionDetailDTO: TransactionDetailDTO, completion: @escaping ((Result<Void, CustomError>) -> Void) {}
}
