import XCTest
@testable import TTravelTogether

class ProfileViewModelTests: XCTestCase {
    var viewModel: ProfileViewModel!
    var mockNetworkService: MockNetworkService!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        viewModel = ProfileViewModel(networkService: mockNetworkService)
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        super.tearDown()
    }

    func testLoadData_WhenNoCacheAndSuccess_ShouldFetchFromNetwork() {
        let expectedUser = User(name: "Test User", phoneNumber: "98790987890")

        viewModel.loadData()

        XCTAssertFalse(viewModel.isLoadingData)
        XCTAssertEqual(viewModel.user?.id, expectedUser.id)
        XCTAssertEqual(viewModel.user?.name, expectedUser.name)
    }

    func testLoadData_WhenNetworkFails_ShouldTriggerOnErrorDidAppear() {
        let expectedError = CustomError.hiddenError("Network error")
        var receivedError: CustomError?

        viewModel.onErrorDidAppear = { error in
            receivedError = error
        }

        viewModel.loadData()

        XCTAssertTrue(viewModel.isLoadingData)
        XCTAssertEqual(receivedError?.localizedDescription, expectedError.localizedDescription)
    }

    func testClearUserCache_ShouldRemoveUserFromCacheAndSetNil() {
        let user = User(id: 1, name: "To Be Cleared")
        viewModel.saveUserToCache(user: user)

        viewModel.clearUserCache()

        XCTAssertNil(viewModel.user)
        XCTAssertNil(viewModel.loadUser())
    }

    private extension ProfileViewModel {
        func saveUserToCache(user: User) {
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(user) as NSData {
                cache.setObject(data, forKey: NSString(string: .AppStrings.Cache.userKey))
            }
        }
    }
}
