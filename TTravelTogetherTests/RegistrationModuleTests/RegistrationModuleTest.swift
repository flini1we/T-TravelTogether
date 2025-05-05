import XCTest
import Combine
@testable import TTravelTogether

final class RegistrationModuleTest: XCTestCase {
    
    private var registrationViewModel: Registratable!
    
    override func setUp() {
        super.setUp()
        registrationViewModel = RegistrationViewModel()
    }
    
    override func tearDown() {
        registrationViewModel = nil
        super.tearDown()
    }
    
    func testIsFetchingRequestPublisher() {
        let expectation = expectation(description: "isFetchingRequestPublisher should sink values")
        var receivedValues: [Bool] = []
        
        let cancellable = registrationViewModel.isFetchingRequestPublisher
            .sink { isFetching in
                receivedValues.append(isFetching)
                if receivedValues.count == 2 {
                    expectation.fulfill()
                }
            }
        
        registrationViewModel.isFetchingRequest = true
        registrationViewModel.isFetchingRequest = false
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedValues, [false, true, false])
        cancellable.cancel()
    }
    
    func testIsPhoneValidPublisher() {
        let expectation = expectation(description: "isPhoneValidPublisher should sink values")
        var receivedValues: Bool!
        
        let cancellable = registrationViewModel.isPhoneValidPublisher
            .dropFirst()
            .sink { isValid in
                receivedValues = isValid
                expectation.fulfill()
            }
        
        registrationViewModel.isPhoneValid = true
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedValues, true)
        cancellable.cancel()
    }
    
    func testIsDataValidPublisher() {
        let expectation = expectation(description: "isDataValidPublisher should sink combined values")
        var receivedValues: [Bool] = []
        
        let cancellable = registrationViewModel.isDataValid
            .dropFirst()
            .sink { isValid in
                receivedValues.append(isValid)
                if receivedValues.count == 3 {
                    expectation.fulfill()
                }
            }
        
        registrationViewModel.isPhoneValid = true
        registrationViewModel.isPasswordValid = true
        registrationViewModel.isPasswordConfirmed = true
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedValues, [false, false, true])
        cancellable.cancel()
    }
    
    func testPasswordPublisher() {
        let expectation = expectation(description: "passwordValidPublisher should sink")
        var receivedValues: Bool = false
        
        let cancellable = registrationViewModel.isPasswordValidPublisher
            .dropFirst()
            .sink { isValid in
                receivedValues = isValid
                expectation.fulfill()
            }
        
        let _ = registrationViewModel.validatePassword("ValidPass123!")
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedValues, true)
        cancellable.cancel()
    }
    
    func testPasswordConfirmedPublisherEmitsOnValidation() {
        let expectation = expectation(description: "passwordConfirmedPublisher should sink")
        var receivedValues: [Bool] = []
        
        let cancellable = registrationViewModel.isPasswordConfirmedPublisher
            .sink { isValid in
                receivedValues.append(isValid)
                if receivedValues.count == 2 {
                    expectation.fulfill()
                }
            }
        
        // Setup
        _ = registrationViewModel.validatePassword("ValidPass123!")
        _ = registrationViewModel.validatePasswordEquality(original: "ValidPass123!", confirmed: "ValidPass123!")
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedValues, [false, true])
        cancellable.cancel()
    }
    
    func testRegisterSuccess() {
        let expectation = expectation(description: "Register should complete successfully")
        
        registrationViewModel.register { result in
            switch result {
            case .success(let message):
                XCTAssertEqual(message, "Valid")
            default: break
            }
            expectation.fulfill()
        }
        
        XCTAssertTrue(registrationViewModel.isFetchingRequest)
        waitForExpectations(timeout: 2)
        XCTAssertFalse(registrationViewModel.isFetchingRequest)
    }
    
    func testValidatePhoneWithValidNumber() {
        let isValid = registrationViewModel.validatePhone("+79123456789")
        XCTAssertTrue(isValid)
        XCTAssertTrue(registrationViewModel.isPhoneValid)
    }
    
    func testValidatePhoneWithInvalidNumber() {
        let invalidPhone = "123456"
        XCTAssertFalse(registrationViewModel.validatePhone(invalidPhone))
        XCTAssertFalse(registrationViewModel.isPhoneValid)
    }
    
    func testValidatePasswordWithValidPassword() {
        let valid = "Password123!"
        XCTAssertTrue(registrationViewModel.validatePassword(valid))
        XCTAssertTrue(registrationViewModel.isPasswordValid)
    }
    
    func testValidatePasswordWithInvalidPassword() {
        let invalidPassword = "short"
        XCTAssertFalse(registrationViewModel.validatePassword(invalidPassword))
        XCTAssertFalse(registrationViewModel.isPasswordValid)
    }
    
    func testValidatePasswordEquality() {
        let password1 = "Password123!"
        let password2 = "Password123!"
        let password3 = "Different123!"
        registrationViewModel.isPasswordValid = true
        
        XCTAssertTrue(registrationViewModel.validatePasswordEquality(original: password1, confirmed: password2))
        XCTAssertTrue(registrationViewModel.isPasswordConfirmed)
        
        XCTAssertFalse(registrationViewModel.validatePasswordEquality(original: password1, confirmed: password3))
        XCTAssertFalse(registrationViewModel.isPasswordConfirmed)
    }
    
    func testValidateEmptyPasswordEquality() {
        XCTAssertFalse(registrationViewModel.validatePasswordEquality(original: nil, confirmed: ""))
        XCTAssertFalse(registrationViewModel.isPasswordConfirmed)
    }
}
