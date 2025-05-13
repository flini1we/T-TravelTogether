import XCTest
@testable import TTravelTogether

final class LoginModuleTest: XCTestCase {
    
    private var loginViewModel: ILoginViewModel!
    
    override func setUp() {
        super.setUp()
        loginViewModel = LoginViewModel()
    }
    
    override func tearDown() {
        loginViewModel = nil
        super.tearDown()
    }

    func testIsLoadingPublisher() {
        let expectation = expectation(description: "isLoadingPublisher should emit values")
        var receivedValues: [Bool] = []
        
        let cancellable = loginViewModel.isLoadingPublisher
            .sink { isLoading in
                receivedValues.append(isLoading)
                if receivedValues.count == 2 {
                    expectation.fulfill()
                }
            }
        loginViewModel.isLoading = true
        loginViewModel.isLoading = false
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedValues, [false, true, false])
        cancellable.cancel()
    }
    
    func testLoginWithValidData() {
        let expectation = expectation(description: "Login should complete")
        let phoneNumber = "1234567890"
        let password = "password123"
        
        loginViewModel.login(phoneNumber: phoneNumber, password: password) { result in
            switch result {
            case .success(let message):
                XCTAssertEqual(message, "Красава")
            case .failure(let error):
                XCTAssertEqual(error, LoginErrors.dataValidationError)
            }
            expectation.fulfill()
        }
        XCTAssertTrue(loginViewModel.isLoading)
        
        waitForExpectations(timeout: 3)
        XCTAssertFalse(loginViewModel.isLoading)
    }
    
    func testLoginWithEmptyPhoneNumber() {
        let expectation = expectation(description: "Login should not complete with empty phone number")
        expectation.isInverted = true
        let phoneNumber = ""
        let password = "password123"
        
        loginViewModel.login(phoneNumber: phoneNumber, password: password) { _ in
            expectation.fulfill()
        }
        
        XCTAssertFalse(loginViewModel.isLoading)
        waitForExpectations(timeout: 0.6)
    }
    
    func testLoginWithEmptyPassword() {
        let expectation = expectation(description: "Login should not complete with empty password")
        expectation.isInverted = true
        let phoneNumber = "1234567890"
        let password = ""
        
        loginViewModel.login(phoneNumber: phoneNumber, password: password) { _ in
            expectation.fulfill()
        }
        
        XCTAssertFalse(loginViewModel.isLoading)
        waitForExpectations(timeout: 0.6)
    }
    
    func testLoginWithEmptyData() {
        let expectation = expectation(description: "Login should not complete with empty credentials")
        expectation.isInverted = true
        let phoneNumber = ""
        let password = ""
        
        loginViewModel.login(phoneNumber: phoneNumber, password: password) { _ in
            expectation.fulfill()
        }
        
        XCTAssertFalse(loginViewModel.isLoading)
        waitForExpectations(timeout: 0.6)
    }
    
    func testLoginLoadingStateTransition() {
        let expectation = expectation(description: "Login should properly transition loading states")
        let phoneNumber = "1234567890"
        let password = "password123"
        
        loginViewModel.login(phoneNumber: phoneNumber, password: password) { _ in
            expectation.fulfill()
        }

        XCTAssertTrue(loginViewModel.isLoading)
        waitForExpectations(timeout: 3)
        XCTAssertFalse(loginViewModel.isLoading)
    }
}
