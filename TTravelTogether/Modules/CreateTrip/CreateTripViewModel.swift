import Foundation
import Combine
import Contacts
import ContactsUI

final class CreateTripViewModel: NSObject, ICreateTripViewModel {
    var onClearingController: (() -> Void)?

    @Published var tripMembers: [User] = []
    @Published private(set) var isCreateButtonEnable: Bool = false
    @Published var tripTitleText: String = ""
    @Published var tripPriceText: String = ""

    var isCreateButtonEnablePublisher: Published<Bool>.Publisher {
        $isCreateButtonEnable
    }
    var tripTitleTextPublisher: Published<String>.Publisher {
        $tripTitleText
    }
    var tripPricePublisher: Published<String>.Publisher {
        $tripPriceText
    }
    var tripMembersPublisher: Published<[User]>.Publisher {
        $tripMembers
    }

    private var cancellables = Set<AnyCancellable>()

    init(_ user: User) {
        super.init()
        tripMembers.append(user)
        setupBindings()
    }

    func addMembers(phoneNumbers: [String]) {
        let users = phoneNumbers.map { User(phoneNumber: $0) }
        tripMembers.append(contentsOf: users)
    }

    func clearData() {
        /// чищу руками потому что в factory scope стоит .container чтоб coordinator не сбивался при пересозданиях
        tripMembers = [tripMembers[0]]
        tripTitleText = ""
        tripPriceText = ""
        onClearingController?()
    }
}

extension CreateTripViewModel: CNContactPickerDelegate {

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        var selectedPhoneNumbers: [String] = []

        for contact in contacts {
            if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                selectedPhoneNumbers.append(phoneNumber)
            }
        }
        addMembers(phoneNumbers: selectedPhoneNumbers)
    }
}

private extension CreateTripViewModel {

    func setupBindings() {
        Publishers.CombineLatest($tripTitleText, $tripPriceText)
            .map { !$0.isEmpty && !$1.isEmpty }
            .assign(to: \.isCreateButtonEnable, on: self)
            .store(in: &cancellables)
    }
}
