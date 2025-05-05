import Foundation
import Combine

final class TripDetailViewModel: TripDetailVMProtocol {

    var tripId: UUID

    @Published var tripDetail: TripDetail = .getPlaceholder()

    var tripDetailPublisher: Published<TripDetail>.Publisher {
        $tripDetail
    }

    init(tripId: UUID) {
        self.tripId = tripId

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tripDetail = TripDetail(
                id: tripId,
                admin: User(phoneNumber: "+79173981189"),
                members: [
                    User(phoneNumber: "+79173981190"),
                    User(phoneNumber: "+79173981129"),
                    User(phoneNumber: "+79183981129")
                ]
            )
        }
    }
}
