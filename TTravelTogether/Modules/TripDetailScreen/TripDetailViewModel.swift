import Foundation
import Combine

final class TripDetailViewModel: ITripDetailViewModel {
    private var networkService: INetworkService
    var onErrorDidAppear: ((CustomError) -> Void)?

    var tripId: Int
    var currentUser: User

    @Published var tripDetail: TripDetail = .fake()

    var tripDetailPublisher: Published<TripDetail>.Publisher {
        $tripDetail
    }

    init(tripId: Int, user: User, networkService: INetworkService) {
        self.tripId = tripId
        self.currentUser = user
        self.networkService = networkService
        loadData()
    }

    func loadData() {
        networkService.getTripDetail(id: tripId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let tripDetailDTO):
                guard
                    let startsAt = AppFormatter.shared.getDateRepresentationOfString(tripDetailDTO.start),
                    let endsAt = AppFormatter.shared.getDateRepresentationOfString(tripDetailDTO.end)
                else {
                    onErrorDidAppear?(.errorToParseData())
                    return
                }
                tripDetail = TripDetail(
                    id: nil,
                    title: tripDetailDTO.title,
                    price: tripDetailDTO.price,
                    startsAt: startsAt,
                    finishAt: endsAt,
                    admin: tripDetailDTO.admin,
                    members: tripDetailDTO.members
                )
            case .failure(let error):
                onErrorDidAppear?(error)
            }
        }
    }

    func deleteTrip(
        completion: @escaping ((Result<Void, CustomError>) -> Void)
    ) {
        networkService.deleteTrip(tripId: tripId) { result in
            switch result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func isAdmin() -> Bool {
        RussianValidationService.shared.compareTwoPhones(currentUser.phoneNumber, tripDetail.admin.phoneNumber)
    }

    func leaveTrip(
        completion: @escaping ((Result<Void, CustomError>) -> Void)
    ) {
        networkService.leaveTrip(with: tripId) { result in
            switch result {
            case .success(let message):
                completion(.success(message))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
