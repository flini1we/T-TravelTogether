import Foundation
import Combine

protocol IMyTripsViewModel: AnyObject {

    var tripsData: [Trip] { get set }
    var isLoadingData: Bool { get }
    var isLoadingDataPublisher: Published<Bool>.Publisher { get }
    var tripsDataPublisher: Published<[Trip]>.Publisher { get }

    func loadData()
}
