import Foundation
import Combine
import Contacts
import ContactsUI

final class CreateTripViewModel: NSObject, ICreateTripViewModel {
    var onClearingController: (() -> Void)?
    var onShowingIncorrectPriceAlert: ((UIAlertController) -> Void)?

    @Published var tripMembers: [User] = []
    @Published private(set) var isCreateButtonEnable: Bool = false
    @Published var tripTitleText: String = ""
    @Published var tripPriceText: String = ""
    @Published var createdTrip: Trip?
    @Published var editedTrip: TripDetail?

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
    var createdTripPublisher: Published<Trip?>.Publisher {
        $createdTrip
    }
    var editedTripPublisher: Published<TripDetail?>.Publisher {
        $editedTrip
    }
    var selectedUsers = Set<String>()

    private var cancellables = Set<AnyCancellable>()
    private let currentUser: User

    init(_ user: User) {
        self.currentUser = user
        super.init()
        if !isEditing() {
            tripMembers.append(currentUser)
        }
        setupBindings()
    }

    func addMembers(phoneNumbers: [String]) {
        let users = phoneNumbers.map { User(phoneNumber: $0) }
        tripMembers.append(contentsOf: users)
    }

    func clearData() {
        tripMembers = [tripMembers[0]]

        tripTitleText = ""
        tripPriceText = ""
        onClearingController?()
        selectedUsers = []
        editedTrip = nil
    }

    func updateMembers(users: [User]) {
        let users =  users.filter { $0.phoneNumber != currentUser.phoneNumber }
        tripMembers = isEditing()
        ? editedTrip!.getMembersSequence() + users
        : [currentUser] + users
    }

    func obtainContacts() -> [Contact] {
        isEditing()
        ? editedTrip!.getMembersSequence().map {
            Contact(phoneNumber: $0.phoneNumber, firstName: "", secondName: "")
        }
        : tripMembers.map {
            Contact(phoneNumber: $0.phoneNumber, firstName: "", secondName: "")
        }
    }

    func createTrip(dates: (start: Date, finish: Date)) {
        guard let price = Int(tripPriceText) else {
            onShowingIncorrectPriceAlert?(AlertFactory.showIncorrectTripPriceAlert())
            return
        }

        let trip = Trip(
            title: tripTitleText,
            startsAt: dates.start,
            finishAt: dates.finish,
            price: price
        )
        let tripDetail = TripDetail(
            id: trip.id,
            title: trip.title,
            price: trip.price,
            startsAt: trip.startsAt,
            finishAt: trip.finishAt,
            admin: tripMembers[0],
            members: Array(tripMembers[1...])
        )
        // TODO: send to backend
        createdTrip = trip
    }

    func isEditing() -> Bool {
        editedTrip != nil
    }
}

extension CreateTripViewModel: CNContactPickerDelegate {

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        var selectedPhoneNumbers: [String] = []

        for contact in contacts {
            if let phoneNumber = contact.phoneNumbers.first?.value.stringValue,
               selectedUsers.insert(phoneNumber).inserted {
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
