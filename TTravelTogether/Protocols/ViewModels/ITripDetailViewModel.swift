import Foundation

protocol ITripDetailViewModel: AnyObject {

    var tripId: UUID { get }
    var currentUser: User { get }

    var tripDetail: TripDetail { get }

    var tripDetailPublisher: Published<TripDetail>.Publisher { get }

    func isAdmin() -> Bool
}
