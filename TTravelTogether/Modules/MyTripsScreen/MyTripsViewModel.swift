import Foundation
import Combine

final class MyTripsViewModel: IMyTripsViewModel {
    @Published var isLoadingData: Bool = false
    var isLoadingDataPublisher: Published<Bool>.Publisher {
        $isLoadingData
    }
    @Published var tripsData: [Trip] = []
    var tripsDataPublisher: Published<[Trip]>.Publisher {
        $tripsData
    }

    init() {
        loadData()
    }

    func loadData() {
        isLoadingData = true
        tripsData = []
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoadingData = false
            self.tripsData = Trip.obtainData()
        }
    }
}
