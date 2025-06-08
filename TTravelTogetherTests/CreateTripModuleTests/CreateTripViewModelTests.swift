import XCTest
import Combine
import Contacts
@testable import TTravelTogether

class CreateTripViewModelTests: XCTestCase {
    
    var sut: CreateTripViewModel!
    var mockNetworkService: INetworkService!
    var mockUser: User!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockUser = User(phoneNumber: "+1234567890")
        mockNetworkService = MockNetworkService()
        sut = CreateTripViewModel(mockUser, networkService: mockNetworkService)
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        mockUser = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(sut.tripMembers.count, 1)
        XCTAssertEqual(sut.tripMembers.first?.phoneNumber, mockUser.phoneNumber)
        XCTAssertFalse(sut.isCreateButtonEnable)
        XCTAssertTrue(sut.tripTitleText.isEmpty)
        XCTAssertTrue(sut.tripPriceText.isEmpty)
        XCTAssertNil(sut.createdTrip)
        XCTAssertNil(sut.editedTrip)
    }
    
    func testCreateButtonEnableState() {
        XCTAssertFalse(sut.isCreateButtonEnable)
        
        sut.tripTitleText = "Test Trip"
        XCTAssertFalse(sut.isCreateButtonEnable)
        
        sut.tripTitleText = ""
        sut.tripPriceText = "100"
        XCTAssertFalse(sut.isCreateButtonEnable)
        
        sut.tripTitleText = "Test Trip"
        sut.tripPriceText = "100"
        XCTAssertTrue(sut.isCreateButtonEnable)
    }
        
    func testAddMembers() {
        let newMembers = ["+1987654321", "+1555666777"]
        
        sut.addMembers(phoneNumbers: newMembers)
        
        XCTAssertEqual(sut.tripMembers.count, 3)
        XCTAssertEqual(sut.tripMembers[1].phoneNumber, newMembers[0])
        XCTAssertEqual(sut.tripMembers[2].phoneNumber, newMembers[1])
    }
    
    func testUpdateMembers() {
        let initialMembers = [
            User(phoneNumber: "+1111111111"),
            User(phoneNumber: "+1222222222")
        ]
        sut.tripMembers.append(contentsOf: initialMembers)
        
        let updatedMembers = [
            User(phoneNumber: "+1333333333"),
            User(phoneNumber: "+1444444444")
        ]
        
        sut.updateMembers(users: updatedMembers)
        
        XCTAssertEqual(sut.tripMembers.count, 3)
        XCTAssertEqual(sut.tripMembers[0].phoneNumber, mockUser.phoneNumber)
        XCTAssertEqual(sut.tripMembers[1].phoneNumber, updatedMembers[0].phoneNumber)
        XCTAssertEqual(sut.tripMembers[2].phoneNumber, updatedMembers[1].phoneNumber)
    }
    
    func testClearData() {
        sut.tripTitleText = "Test"
        sut.tripPriceText = "100"
        sut.tripMembers.append(User(phoneNumber: "+1111111111"))
        sut.selectedUsers.insert("+1111111111")
        
        var clearingCalled = false
        sut.onClearingController = { clearingCalled = true }
        
        sut.clearData()
        
        XCTAssertTrue(clearingCalled)
        XCTAssertEqual(sut.tripMembers.count, 1)
        XCTAssertEqual(sut.tripMembers.first?.phoneNumber, mockUser.phoneNumber)
        XCTAssertTrue(sut.tripTitleText.isEmpty)
        XCTAssertTrue(sut.tripPriceText.isEmpty)
        XCTAssertTrue(sut.selectedUsers.isEmpty)
    }
    
    func testCreateTripSuccess() {
        let expectation = self.expectation(description: "Create trip success")
        let testDates = (Date(), Date().addingTimeInterval(86400))
        let testTripDetail = TripDetail(
            id: 1,
            title: "Test Trip",
            price: 100,
            startsAt: testDates.0,
            finishAt: testDates.1,
            admin: mockUser,
            members: []
        )
        
        sut.tripTitleText = "Test Trip"
        sut.tripPriceText = "100"
        
        sut.createTrip(dates: testDates) { result in
            switch result {
            case .success(let tripDetail):
                XCTAssertEqual(tripDetail.title, "Test Trip")
                XCTAssertEqual(tripDetail.price, 100)
                expectation.fulfill()
            case .failure:
                XCTFail("Should succeed")
            }
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testCreateTripWithInvalidPrice() {
        let expectation = self.expectation(description: "Invalid price alert")
        let testDates = (Date(), Date())
        
        var alertPresented = false
        sut.onShowingIncorrectPriceAlert = { _ in
            alertPresented = true
            expectation.fulfill()
        }
        
        sut.tripTitleText = "Test Trip"
        sut.tripPriceText = "invalid"
        
        sut.createTrip(dates: testDates) { _ in
            XCTFail("Should not complete")
        }
        
        waitForExpectations(timeout: 1)
        XCTAssertTrue(alertPresented)
    }
    
    func testUpdateTripSuccess() {
        let expectation = self.expectation(description: "Update trip success")
        let editedTrip = TripDetail(
            id: 1,
            title: "Original",
            price: 50,
            startsAt: Date(),
            finishAt: Date().addingTimeInterval(86400),
            admin: mockUser,
            members: []
        )
        
        sut.editedTrip = editedTrip
        sut.ogId = 1
        sut.tripTitleText = "Updated"
        sut.tripPriceText = "200"
        
        let testDates = (Date(), Date().addingTimeInterval(86400 * 2))
        sut.onDataHandling = { testDates }
        
        sut.updateTrip { result in
            switch result {
            case .success(let dto):
                XCTAssertEqual(dto.title, "Updated")
                XCTAssertEqual(dto.price, 200)
                expectation.fulfill()
            case .failure:
                XCTFail("Should succeed")
            }
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testUpdateTripWithoutEditedTrip() {
        let expectation = self.expectation(description: "Update without edited trip")
        
        sut.updateTrip { result in
            if case .failure(let error) = result {
                XCTAssertEqual(error.message, "Error to edit trip")
                expectation.fulfill()
            } else {
                XCTFail("Should fail")
            }
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testIsEditing() {
        XCTAssertFalse(sut.isEditing())
        
        sut.editedTrip = TripDetail(
            id: 1,
            title: "Test",
            price: 100,
            startsAt: Date(),
            finishAt: Date(),
            admin: mockUser,
            members: []
        )
        
        XCTAssertTrue(sut.isEditing())
    }
    
    func testObtainContacts() {
        let members = [
            User(phoneNumber: "+1111111111"),
            User(phoneNumber: "+1222222222")
        ]
        sut.tripMembers.append(contentsOf: members)
        
        let contacts = sut.obtainContacts()
        
        XCTAssertEqual(contacts.count, 3)
        XCTAssertEqual(contacts[0].phoneNumber, mockUser.phoneNumber)
        XCTAssertEqual(contacts[1].phoneNumber, members[0].phoneNumber)
    }
}

