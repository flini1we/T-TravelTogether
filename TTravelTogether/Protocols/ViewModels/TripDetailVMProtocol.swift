import Foundation

protocol TripDetailVMProtocol: AnyObject {

    var tripId: UUID { get }

    var tripDetail: TripDetail { get }

    var tripDetailPublisher: Published<TripDetail>.Publisher { get }
}
