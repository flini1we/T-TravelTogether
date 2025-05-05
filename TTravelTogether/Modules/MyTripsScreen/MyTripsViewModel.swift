import Foundation
import Combine

final class MyTripsViewModel: IMyTripsViewModel {

    var tripsData: [Trip] = []

    init() {
        loadData()
    }

    func loadData() {
        self.tripsData = Trip.obtainMock()
    }
}
