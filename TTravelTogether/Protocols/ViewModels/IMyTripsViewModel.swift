import Foundation
import Combine

protocol IMyTripsViewModel: AnyObject {

    var onErrorDidAppear: ((CustomError) -> Void)? { get set }
    var tripsData: [Trip] { get set }
    var isLoadingData: Bool { get }
    var isLoadingDataPublisher: Published<Bool>.Publisher { get }
    var tripsDataPublisher: Published<[Trip]>.Publisher { get }

    func loadData()
}
