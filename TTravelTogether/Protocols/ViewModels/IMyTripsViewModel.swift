import Foundation
import Combine

protocol IMyTripsViewModel: AnyObject {

    var tripsData: [Trip] { get set }
    var onTripsUpdate: (([Trip]) -> Void)? { get set }
    var isLoadingData: Bool { get }
    var isLoadingDataPublisher: Published<Bool>.Publisher { get }

    func loadData()
}
