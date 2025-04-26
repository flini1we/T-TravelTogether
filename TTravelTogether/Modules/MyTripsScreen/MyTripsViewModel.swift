import Foundation
import Combine

final class MyTripsViewModel: MyTripsVMProtocol {

    var tripsData: [Trip]

    init(tripsData: [Trip]) {
        self.tripsData = tripsData
    }
}
