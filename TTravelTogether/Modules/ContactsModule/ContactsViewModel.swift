import UIKit
import Contacts
import ContactsUI
import Combine

final class ContactsViewModel: IContactsViewModel {

    private(set) var contacts = CurrentValueSubject<[Contact], Never>([])
    var selectedContacts: Set<Contact>
    private let store = CNContactStore()
    private var cancellables = Set<AnyCancellable>()

    var onRequestAccess: ((UIAlertController) -> Void)?

    init(selectedContacts: [Contact]) {
        self.selectedContacts = Set(selectedContacts)
        DispatchQueue.global(qos: .userInitiated).async {
            self.requestContactsAccess()
        }
    }

    func clearData() {
        selectedContacts = []
    }
}

private extension ContactsViewModel {

    func requestContactsAccess() {
        store.requestAccess(for: .contacts) { [weak self] granted, _ in
            guard let self = self else { return }
            if granted {
                fetchContacts()
            } else {
                onRequestAccess?(
                    AlertFactory.createContactsAccessAlert {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    } onCancel: { }
                )
            }
        }
    }

    func fetchContacts() {
        let keysToFetch = [
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactIdentifierKey
        ] as [CNKeyDescriptor]

        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        request.sortOrder = .givenName

        // TODO: Error handling
        var fetchedContacts: [Contact] = []
        try? self.store.enumerateContacts(with: request) { contact, _ in
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
    }
}
