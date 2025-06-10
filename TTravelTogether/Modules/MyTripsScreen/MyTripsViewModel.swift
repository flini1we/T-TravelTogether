import Foundation
import Combine
import UserNotifications

final class MyTripsViewModel: IMyTripsViewModel {
    private var networkService: INetworkService
    private let notificationCenter: IPushNotificationCenter
    var onErrorDidAppear: ((CustomError) -> Void)?

    @Published var isLoadingData: Bool = false
    var isLoadingDataPublisher: Published<Bool>.Publisher {
        $isLoadingData
    }
    @Published var tripsData: [Trip] = []
    var tripsDataPublisher: Published<[Trip]>.Publisher {
        $tripsData
    }

    init(networkService: INetworkService, notificationCenter: IPushNotificationCenter) {
        self.networkService = networkService
        self.notificationCenter = notificationCenter
        loadData()
    }

    func loadData() {
        isLoadingData = true
        tripsData = []
        networkService.getActiveTrips { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let tripsDTO):
                let responseData: [Trip] = tripsDTO.compactMap({ tripDTO in
                    guard
                        let startDate = AppFormatter.shared.getDateRepresentationOfString(tripDTO.startsAt),
                        let endsDate = AppFormatter.shared.getDateRepresentationOfString(tripDTO.finishAt)
                    else { return nil }
                    return Trip(
                        id: tripDTO.id,
                        title: tripDTO.title,
                        startsAt: startDate,
                        finishAt: endsDate,
                        price: tripDTO.price
                    )
                })
                tripsData = responseData
                isLoadingData = false
            case .failure(let error):
                onErrorDidAppear?(error)
            }
        }
    }

    func mockPush(request: UNNotificationRequest) {
        DispatchQueue.main.async {
            self.notificationCenter.showNotification(for: request) { result in
                switch result {
                case .failure(let error):
                    self.onErrorDidAppear?(error)
                default:
                    break
                }
            }
        }
    }
}
