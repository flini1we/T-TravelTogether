import XCTest
@testable import TTravelTogether
import Combine
import Contacts

final class ContactsViewModelTests: XCTestCase {
    var viewModel: ContactsViewModel!
    var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        // Используем пустой список выбранных контактов для инициализации
        viewModel = ContactsViewModel(selectedContacts: [])
    }

    override func tearDown() {
        viewModel = nil
        cancellables.removeAll()
        super.tearDown()
    }

    // MARK: - clearData Tests

    func testClearData_ShouldEmptySelectedContacts() {
        // Arrange
        let contact = Contact(phoneNumber: "+79123456789", firstName: "Ivan", secondName: "Petrov")
        viewModel.selectedContacts.insert(contact)

        // Act
        viewModel.clearData()

        // Assert
        XCTAssertTrue(viewModel.selectedContacts.isEmpty)
    }

    // MARK: - isContactSelected Tests

    func testIsContactSelected_WhenContactExists_ShouldReturnTrue() {
        // Arrange
        let contact = Contact(phoneNumber: "+79123456789", firstName: "Ivan", secondName: "Petrov")
        viewModel.selectedContacts.insert(contact)

        let newContact = Contact(phoneNumber: "+7 912 345-67-89", firstName: "Ivan", secondName: "Petrov")

        // Act
        let isSelected = viewModel.isContactSelected(newContact)

        // Assert
        XCTAssertTrue(isSelected)
    }

    func testIsContactSelected_WhenContactNotExists_ShouldReturnFalse() {
        // Arrange
        let contact = Contact(phoneNumber: "+79123456789", firstName: "Ivan", secondName: "Petrov")
        viewModel.selectedContacts.insert(contact)

        let newContact = Contact(phoneNumber: "+79991234567", firstName: "Petr", secondName: "Ivanov")

        // Act
        let isSelected = viewModel.isContactSelected(newContact)

        // Assert
        XCTAssertFalse(isSelected)
    }

    // MARK: - removeSelectedContact Tests

    func testRemoveSelectedContact_WhenContactExists_ShouldRemoveIt() {
        // Arrange
        let contact1 = Contact(phoneNumber: "+79123456789", firstName: "Ivan", secondName: "Petrov")
        let contact2 = Contact(phoneNumber: "+79991234567", firstName: "Petr", secondName: "Ivanov")
        viewModel.selectedContacts.formUnion([contact1, contact2])

        // Act
        viewModel.removeSelectedContact(contact1)

        // Assert
        XCTAssertEqual(viewModel.selectedContacts.count, 1)
        XCTAssertTrue(viewModel.selectedContacts.contains(contact2))
    }

    func testRemoveSelectedContact_WhenContactNotExists_ShouldNotChangeSet() {
        // Arrange
        let contact1 = Contact(phoneNumber: "+79123456789", firstName: "Ivan", secondName: "Petrov")
        let contact2 = Contact(phoneNumber: "+79991234567", firstName: "Petr", secondName: "Ivanov")
        viewModel.selectedContacts.formUnion([contact1])

        // Act
        viewModel.removeSelectedContact(contact2)

        // Assert
        XCTAssertEqual(viewModel.selectedContacts.count, 1)
        XCTAssertTrue(viewModel.selectedContacts.contains(contact1))
    }

    // MARK: - Contacts Fetching Tests (Mocked Store)

    func testFetchContacts_WhenAccessGranted_ShouldPopulateContacts() {
        // Arrange
        let mockStore = MockCNContactStore()
        let contact = CNContact()
        contact.givenName = "Anna"
        contact.familyName = "Smith"
        contact.phoneNumbers = [CNLabeledValue(label: nil, value: CNPhoneNumber(stringValue: "+79123456789"))]

        mockStore.contactsToReturn = [contact]
        let expectation = XCTestExpectation(description: "Contacts fetched")

        let vm = ContactsViewModelWithMockStore(store: mockStore, selectedContacts: [])

        // Act
        vm.contacts.values.first { contacts in
            contacts.count == 1
        }?.sink { contacts in
            XCTAssertEqual(contacts.count, 1)
            XCTAssertEqual(contacts[0].firstName, "Anna")
            XCTAssertEqual(contacts[0].secondName, "Smith")
            XCTAssertEqual(contacts[0].phoneNumber, "+79123456789")
            expectation.fulfill()
        }.store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testRequestContactsAccess_WhenDenied_ShouldTriggerOnRequestAccess() {
        // Arrange
        let mockStore = MockCNContactStore()
        mockStore.accessGranted = false
        var alertTriggered = false

        let vm = ContactsViewModelWithMockStore(store: mockStore, selectedContacts: [])
        vm.onRequestAccess = { _ in
            alertTriggered = true
        }

        // Act
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Ждём выполнения requestAccess
            XCTAssertTrue(alertTriggered)
        }

        waitForMainQueue()
    }

    func testRequestContactsAccess_WhenGranted_ShouldCallFetchContacts() {
        // Arrange
        let mockStore = MockCNContactStore()
        mockStore.accessGranted = true
        var contactsLoaded = false

        let vm = ContactsViewModelWithMockStore(store: mockStore, selectedContacts: [])

        vm.contacts.values.first(where: { $0.isNotEmpty })?
            .sink { contacts in
                contactsLoaded = true
            }.store(in: &cancellables)

        // Act
        waitForMainQueue()

        // Assert
        XCTAssertTrue(contactsLoaded)
    }

    // MARK: - Helper Methods

    private func waitForMainQueue(timeout: TimeInterval = 1.0) {
        let exp = XCTestExpectation(description: "Wait for async queue")
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: timeout + 0.1)
    }
}

// MARK: - Mock Classes

class MockCNContactStore: CNContactStoreProtocol {
    var accessGranted = true
    var contactsToReturn: [CNContact] = []

    func requestAccess(for entityType: CNEntityType, completionHandler: @escaping (Bool, Error?) -> Void) {
        completionHandler(accessGranted, nil)
    }

    func enumerateContacts(with fetchRequest: CNContactFetchRequest, using block: (CNContact, UnsafeMutablePointer<ObjCBool>) throws -> Void) throws {
        for contact in contactsToReturn {
            let stop: ObjCBool = false
            try block(contact, &stop)
            if stop.boolValue {
                break
            }
        }
    }
}

protocol CNContactStoreProtocol {
    func requestAccess(for entityType: CNEntityType, completionHandler: @escaping (Bool, Error?) -> Void)
    func enumerateContacts(with fetchRequest: CNContactFetchRequest, using block: (CNContact, UnsafeMutablePointer<ObjCBool>) throws -> Void) throws
}

extension CNContactStore: CNContactStoreProtocol {}

// MARK: - ViewModel with Mock Store

final class ContactsViewModelWithMockStore: ContactsViewModel {
    init(store: CNContactStoreProtocol, selectedContacts: [Contact]) {
        super.init(selectedContacts: selectedContacts)
        self.store = store
    }

    private var store: CNContactStoreProtocol = CNContactStore()

    override func requestContactsAccess() {
        store.requestAccess(for: .contacts) { [weak self] granted, _ in
            guard let self else { return }
            if granted {
                fetchContacts()
            } else {
                onRequestAccess?(
                    AlertFactory.createContactsAccessAlert {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    } onCancel: {}
                )
            }
        }
    }

    override func fetchContacts() {
        let keysToFetch = [
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactIdentifierKey
        ] as [CNKeyDescriptor]

        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        request.sortOrder = .givenName

        var fetchedContacts: [Contact] = []
        do {
            try (store as! MockCNContactStore).enumerateContacts(with: request) { contact, _ in
                if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                    fetchedContacts.append(
                        Contact(
                            phoneNumber: phoneNumber,
                            firstName: contact.givenName,
                            secondName: contact.familyName
                        )
                    )
                }
            }
            contacts.send(fetchedContacts)
        } catch {
            contacts.send([])
        }
    }
}
