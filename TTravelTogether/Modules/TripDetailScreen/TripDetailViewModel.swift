import Foundation
import Combine

final class TripDetailViewModel: ITripDetailViewModel {

    var tripId: UUID

    @Published var tripDetail: TripDetail = .fake()

    var tripDetailPublisher: Published<TripDetail>.Publisher {
        $tripDetail
    }

    init(tripId: UUID) {
        self.tripId = tripId

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tripDetail = TripDetail(
                id: tripId,
                title: .AppStrings.AppTitles.tripDetailTitle,
                price: .AppIntegers.tripPricePlaceholder,
                startsAt: .now,
                finishAt: .now,
                admin: User(phoneNumber: "+79173981189"),
                members: [
                    User(phoneNumber: "+79173981190"),
                    User(phoneNumber: "+79173981129"),
                    User(phoneNumber: "+79183981129")
                ]
            )
        }
    }

    func isAdmin() -> Bool {
        UserService.shared.currentUser! == tripDetail.admin
    }
}
