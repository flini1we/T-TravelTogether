import Foundation
import Combine

final class MyTripsViewModel: MyTripsVMProtocol {

    var tripsData: [Trip] = []

    init() {
        loadData()
    }

    func loadData() {
        self.tripsData = Trip.obtainMock()
    }
}
