import Foundation
import Combine

final class MyTripsViewModel: IMyTripsViewModel {
    private var networkService: INetworkService
    var onErrorDidAppear: ((CustomError) -> Void)?

    @Published var isLoadingData: Bool = false
    var isLoadingDataPublisher: Published<Bool>.Publisher {
        $isLoadingData
    }
    @Published var tripsData: [Trip] = []
    var tripsDataPublisher: Published<[Trip]>.Publisher {
        $tripsData
    }

    init(networkService: INetworkService) {
        self.networkService = networkService
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
}
