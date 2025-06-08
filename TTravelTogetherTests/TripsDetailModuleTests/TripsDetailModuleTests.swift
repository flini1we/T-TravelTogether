import XCTest
@testable import TTravelTogether
import Combine

final class TripDetailViewModelTests: XCTestCase {
    var viewModel: TripDetailViewModel!
    var networkService: MockNetworkService!
    var cancellables = Set<AnyCancellable>()
    
    let testUser = User(phoneNumber: "+79123456789", firstName: "Ivan", secondName: "Petrov")
    let testTripId = 123

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

    func testLoadData_WhenSuccess_ShouldUpdateTripDetail() {
        // Arrange
        let expectedDTO = TripDetailDTO(
            id: testTripId,
            title: "Test Trip",
            price: 100.0,
            start: "2025-04-01T12:00:00Z",
            end: "2025-04-10T12:00:00Z",
            admin: testUser,
            members: [testUser]
        )

        networkService.getTripDetailResult = .success(expectedDTO)

        let expectation = XCTestExpectation(description: "Trip detail updated")

        viewModel = TripDetailViewModel(tripId: testTripId, user: testUser, networkService: networkService)

        viewModel.tripDetailPublisher
            .dropFirst()
            .sink { tripDetail in
                XCTAssertEqual(tripDetail.title, expectedDTO.title)
                XCTAssertEqual(tripDetail.price, expectedDTO.price)
                XCTAssertEqual(tripDetail.admin.phoneNumber, expectedDTO.admin.phoneNumber)
                XCTAssertEqual(tripDetail.members.count, expectedDTO.members.count)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadData_WhenParseError_ShouldTriggerOnErrorDidAppear() {
        // Arrange
        let invalidDateDTO = TripDetailDTO(
            id: testTripId,
            title: "Invalid Date Trip",
            price: 100.0,
            start: "invalid-date-format",
            end: "invalid-end-date",
            admin: testUser,
            members: [testUser]
        )

        networkService.getTripDetailResult = .success(invalidDateDTO)
        var receivedError: CustomError?

        let expectation = XCTestExpectation(description: "Error triggered on date parse failure")

        viewModel = TripDetailViewModel(tripId: testTripId, user: testUser, networkService: networkService)
        viewModel.onErrorDidAppear = { error in
            receivedError = error
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(receivedError, .errorToParseData())
    }

    func testLoadData_WhenNetworkFailure_ShouldTriggerOnErrorDidAppear() {
        // Arrange
        networkService.getTripDetailResult = .failure(.hiddenError("Network error"))
        var receivedError: CustomError?

        let expectation = XCTestExpectation(description: "Error triggered on network failure")

        viewModel = TripDetailViewModel(tripId: testTripId, user: testUser, networkService: networkService)
        viewModel.onErrorDidAppear = { error in
            receivedError = error
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(receivedError?.localizedDescription, "Network error")
    }

    // MARK: - isAdmin Tests

    func testIsAdmin_WhenCurrentUserIsAdmin_ShouldReturnTrue() {
        // Arrange
        let admin = User(phoneNumber: "+79123456789", firstName: "Admin", secondName: "User")
        let tripDetail = TripDetail(
            id: nil,
            title: "Admin Trip",
            price: 0,
            startsAt: Date(),
            finishAt: Date(),
            admin: admin,
            members: []
        )

        viewModel = TripDetailViewModel(tripId: testTripId, user: admin, networkService: networkService)
        viewModel.tripDetail = tripDetail

        // Act
        let result = viewModel.isAdmin()

        // Assert
        XCTAssertTrue(result)
    }

    func testIsAdmin_WhenCurrentUserNotAdmin_ShouldReturnFalse() {
        // Arrange
        let admin = User(phoneNumber: "+79123456789", firstName: "Admin", secondName: "User")
        let nonAdmin = User(phoneNumber: "+79999999999", firstName: "Non", secondName: "Admin")
        let tripDetail = TripDetail(
            id: nil,
            title: "Non Admin Trip",
            price: 0,
            startsAt: Date(),
            finishAt: Date(),
            admin: admin,
            members: []
        )

        viewModel = TripDetailViewModel(tripId: testTripId, user: nonAdmin, networkService: networkService)
        viewModel.tripDetail = tripDetail

        // Act
        let result = viewModel.isAdmin()

        // Assert
        XCTAssertFalse(result)
    }

    // MARK: - leaveTrip Tests

    func testLeaveTrip_WhenSuccess_ShouldCallCompletionWithSuccess() {
        // Arrange
        networkService.leaveTripResult = .success(())

        let expectation = XCTestExpectation(description: "leaveTrip completion called with success")

        viewModel = TripDetailViewModel(tripId: testTripId, user: testUser, networkService: networkService)
        viewModel.leaveTrip { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, got failure instead")
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testLeaveTrip_WhenFailure_ShouldCallCompletionWithFailure() {
        // Arrange
        let error = CustomError.hiddenError("Could not leave trip")
        networkService.leaveTripResult = .failure(error)

        let expectation = XCTestExpectation(description: "leaveTrip completion called with failure")

        viewModel = TripDetailViewModel(tripId: testTripId, user: testUser, networkService: networkService)
        viewModel.leaveTrip { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success instead")
            case .failure(let err):
                XCTAssertEqual(err.localizedDescription, error.localizedDescription)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }
}

// MARK: - Mock Network Service

class MockNetworkService: INetworkService {
    var getTripDetailResult: Result<TripDetailDTO, CustomError>?
    var leaveTripResult: Result<Void, CustomError>?

    func getTripDetail(id: Int, completion: @escaping (Result<TripDetailDTO, CustomError>) -> Void) {
        if let result = getTripDetailResult {
            completion(result)
        }
    }

    func leaveTrip(with id: Int, completion: @escaping ((Result<Void, CustomError>) -> Void)) {
        if let result = leaveTripResult {
            completion(result)
        }
    }

    // MARK: - Unused Methods (Stubbed)
    
    func register(user: UserDTO, completion: @escaping (Result<String, CustomError>) -> Void) {}
    func login(userData: LoginUserDataType, completion: @escaping ((Result<LoginUserDataType, CustomError>) -> Void) {}
    func createTrip(tripDetail: CreateTripDTO, completion: @escaping ((Result<CreateTripDTO, CustomError>) -> Void) {}
    func getActiveTrips(completion: @escaping ((Result<[TripDTO], CustomError>) -> Void) {}
    func updateTrip(tripDetail: EditTripDTO, completion: @escaping ((Result<EditTripDTO, CustomError>) -> Void) {}
    func getUserProfile(completion: @escaping ((Result<User, CustomError>) -> Void) {}
    func getTransactions(tripId: Int, completion: @escaping ((Result<[TransactionDTO], CustomError>) -> Void) {}
    func createTransaction(travelId: Int, createdTransaction: CreatedTransactionDTO, completion: @escaping ((Result<Void, CustomError>) -> Void) {}
    func getTransactionDetail(transactionId id: Int, completion: @escaping ((Result<TransactionDetailDTO, CustomError>) -> Void) {}
    func updateTransaction(transactionDetailDTO: TransactionDetailDTO, completion: @escaping ((Result<Void, CustomError>) -> Void) {}
    func deleteTransaction(id: Int, completion: @escaping ((Result<Void, CustomError>) -> Void) {}
}
