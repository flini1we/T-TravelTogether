import Foundation

protocol ITripDetailViewModel: AnyObject {
    var onErrorDidAppear: ((CustomError) -> Void)? { get set }

    var tripId: Int { get }
    var currentUser: User { get }

    var tripDetail: TripDetail { get }

    var tripDetailPublisher: Published<TripDetail>.Publisher { get }

    func isAdmin() -> Bool
    func leaveTrip(
        completion: @escaping ((Result<Void, CustomError>) -> Void)
    )
    func loadData()
}
