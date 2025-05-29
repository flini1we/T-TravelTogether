import Foundation
import Combine
import Contacts
import ContactsUI

final class CreateTripViewModel: NSObject, ICreateTripViewModel {
    private var networkService: INetworkService
    var ogId: Int?
    var onClearingController: (() -> Void)?
    var onShowingIncorrectPriceAlert: ((UIAlertController) -> Void)?

    @Published var tripMembers: [User] = []
    @Published private(set) var isCreateButtonEnable: Bool = false
    @Published var tripTitleText: String = ""
    @Published var tripPriceText: String = ""
    @Published var createdTrip: TripDetail?
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
    var createdTripPublisher: Published<TripDetail?>.Publisher {
        $createdTrip
    }
    var editedTripPublisher: Published<TripDetail?>.Publisher {
        $editedTrip
    }
    var selectedUsers = Set<String>()
    var onDataHandling: (() -> (Date, Date)?)?

    private var cancellables = Set<AnyCancellable>()
    private let currentUser: User

    init(_ user: User, networkService: INetworkService) {
        self.currentUser = user
        self.networkService = networkService
        super.init()
        if !isEditing() {
            tripMembers.append(currentUser)
        }
        setupBindings()
    }

    func addMembers(phoneNumbers: [String]) {
        let users = phoneNumbers.map {
            User(phoneNumber: $0)
        }
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

    func createTrip(
        dates: (start: Date, finish: Date),
        completion: @escaping ((Result<TripDetail, CustomError>) -> Void)
    ) {
        guard let price = Int(tripPriceText) else {
            onShowingIncorrectPriceAlert?(AlertFactory.showIncorrectTripPriceAlert())
            return
        }
        let tripDetail = TripDetail(
            id: nil,
            title: tripTitleText,
            price: price,
            startsAt: dates.start,
            finishAt: dates.finish,
            admin: tripMembers[0],
            members: Array(tripMembers[1...])
        )

        let tripDetailDTO = CreateTripDTO(
            title: tripDetail.title,
            price: price,
            start: AppFormatter.shared.getStringRepresentationOfDateISO(tripDetail.startsAt),
            end: AppFormatter.shared.getStringRepresentationOfDateISO(tripDetail.finishAt),
            participants: tripDetail.members.map({
                RussianValidationService.shared.invalidate(phone: $0.phoneNumber)
            })
        )
        networkService.createTrip(tripDetail: tripDetailDTO) { result in
            switch result {
            case .success(let tripDetailDTO):
                completion(.success(tripDetail))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateTrip(
        completion: @escaping ((Result<EditTripDTO, CustomError>) -> Void)
    ) {
        guard let editedTrip else { completion(.failure(.errorToEditTrip())); return }
        guard let ogId else { completion(.failure(.editedTripIdIsNil())); return }
        guard let price = Int(tripPriceText) else { completion(.failure(.errorToParseData())); return }
        guard
            let tripData = self.onDataHandling,
            let start = tripData()?.0,
            let end = tripData()?.1
        else { completion(.failure(.errorToAccassTripData())); return }
        let editedTripStart = AppFormatter.shared.getStringRepresentationOfDateISO(start),
            editedTripEnd = AppFormatter.shared.getStringRepresentationOfDateISO(end)
        let tripDetailDTO = EditTripDTO(
            id: ogId,
            title: tripTitleText,
            price: price,
            start: editedTripStart,
            end: editedTripEnd,
            admin: editedTrip.admin,
            members: Array(tripMembers[1...])
        )
        networkService.updateTrip(tripDetail: tripDetailDTO) { result in
            switch result {
            case .success(let editedTripDTO):
                completion(.success(editedTripDTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
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
