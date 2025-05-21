import Foundation
import Combine

final class MyTripsViewModel: IMyTripsViewModel {
    @Published var isLoadingData: Bool = false
    var isLoadingDataPublisher: Published<Bool>.Publisher {
        $isLoadingData
    }

    var tripsData: [Trip] = Trip.fake() {
        didSet {
            onTripsUpdate?(tripsData)
        }
    }
    var onTripsUpdate: (([Trip]) -> Void)?

    init() {
        loadData()
    }

    func loadData() {
        isLoadingData = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoadingData = false
            self.tripsData = Trip.obtainData()
        }
    }
}
