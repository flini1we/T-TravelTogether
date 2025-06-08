import XCTest
import Combine
@testable import TTravelTogether

class MyTripsViewModelTests: XCTestCase {
    
    var sut: MyTripsViewModel!
    var mockNetworkService: MockNetworkService!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        sut = MyTripsViewModel(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testLoadData_Success() {
        let testTripsDTO = [TripDTO(
            id: 0,
            title: "Test",
            startsAt: "2023-01-01",
            finishAt: "2023-01-10",
            price: 100
        )]
        mockNetworkService.getActiveTripsResult = .success(testTripsDTO)
        let expectation = self.expectation(description: "Trips data loaded")
        
        sut.loadData()
        sut.$tripsData
            .dropFirst()
            .sink { trips in
                XCTAssertEqual(trips.count, 1)
                XCTAssertEqual(trips.first?.id, 1)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    func testLoadData_Failure() {
        let testError = CustomError(message: "Test error")
        mockNetworkService.getActiveTripsResult = .failure(testError)
        let expectation = self.expectation(description: "Error received")
        
        sut.onErrorDidAppear = { error in
            XCTAssertEqual(error.message, "Test error")
            expectation.fulfill()
        }
        sut.loadData()
        
        waitForExpectations(timeout: 1)
    }
    
    func testLoadData_LoadingState() {
        let testTripsDTO = [TripDTO]()
        mockNetworkService.getActiveTripsResult = .success(testTripsDTO)
        let expectation = self.expectation(description: "Loading state changed")
        var loadingStates = [Bool]()
        
        sut.$isLoadingData
            .sink { isLoading in
                loadingStates.append(isLoading)
                if loadingStates.count == 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.loadData()
        
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(loadingStates, [false, true, false])
        }
    }
}

class MockNetworkService: INetworkService {
    var getActiveTripsResult: Result<[TripDTO], CustomError> = .success([])

    func getActiveTrips(completion: @escaping (Result<[TripDTO], CustomError>) -> Void) {
        completion(getActiveTripsResult)
    }

    func register(user: TTravelTogether.UserDTO, completion: @escaping (Result<String, TTravelTogether.CustomError>) -> Void) {
        fatalError("Not implemented")
    }
    
    func login(userData: TTravelTogether.LoginUserDataType, completion: @escaping ((Result<TTravelTogether.LoginUserDataType, TTravelTogether.CustomError>) -> Void)) {
        fatalError("Not implemented")
    }
    
    func createTrip(tripDetail: TTravelTogether.CreateTripDTO, completion: @escaping ((Result<TTravelTogether.CreateTripDTO, TTravelTogether.CustomError>) -> Void)) {
        fatalError("Not implemented")
    }
    
    func getTripDetail(id: Int, completion: @escaping ((Result<TTravelTogether.TripDetailDTO, TTravelTogether.CustomError>) -> Void)) {
        fatalError("Not implemented")
    }
    
    func updateTrip(tripDetail: TTravelTogether.EditTripDTO, completion: @escaping ((Result<TTravelTogether.EditTripDTO, TTravelTogether.CustomError>) -> Void)) {
        fatalError("Not implemented")
    }
    
    func leaveTrip(with id: Int, completion: @escaping ((Result<Void, TTravelTogether.CustomError>) -> Void)) {
        fatalError("Not implemented")
    }
    
    func getUserProfile(completion: @escaping ((Result<TTravelTogether.User, TTravelTogether.CustomError>) -> Void)) {
        fatalError("Not implemented")
    }
    
    func getTransactions(tripId: Int, completion: @escaping ((Result<[TTravelTogether.TransactionDTO], TTravelTogether.CustomError>) -> Void)) {
        fatalError("Not implemented")
    }
    
    func createTransaction(travelId: Int, createdTransaction: TTravelTogether.CreatedTransactionDTO, completion: @escaping ((Result<Void, TTravelTogether.CustomError>) -> Void)) {
        fatalError("Not implemented")
    }
    
    func getTransactionDetail(transactionId id: Int, completion: @escaping ((Result<TTravelTogether.TransactionDetailDTO, TTravelTogether.CustomError>) -> Void)) {
        fatalError("Not implemented")
    }
    
    func updateTransaction(transactionDetailDTO: TTravelTogether.TransactionDetailDTO, completion: @escaping ((Result<Void, TTravelTogether.CustomError>) -> Void)) {
        fatalError("Not implemented")
    }
    
    func deleteTransaction(id: Int, completion: @escaping ((Result<Void, TTravelTogether.CustomError>) -> Void)) {
        fatalError("Not implemented")
    }
}
