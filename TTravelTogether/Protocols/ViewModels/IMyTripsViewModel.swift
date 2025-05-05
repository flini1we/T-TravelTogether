import Foundation
import Combine

protocol IMyTripsViewModel: AnyObject {

    var tripsData: [Trip] { get set }

    func loadData()
}
