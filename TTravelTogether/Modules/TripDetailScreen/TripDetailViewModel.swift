import Foundation
import Combine

final class TripDetailViewModel: ITripDetailViewModel {

    var tripId: UUID
    var currentUser: User

    @Published var tripDetail: TripDetail = .fake()

    var tripDetailPublisher: Published<TripDetail>.Publisher {
        $tripDetail
    }

    init(tripId: UUID, user: User) {
        self.tripId = tripId
        self.currentUser = user

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tripDetail = TripDetail(
                id: tripId,
                title: .AppStrings.AppTitles.tripDetailTitle,
                price: .AppIntegers.tripPricePlaceholder,
                startsAt: .now,
                finishAt: .now,
                admin: self.currentUser,
                members: [
                    User(phoneNumber: "+79173981190"),
                    User(phoneNumber: "+79173981129"),
                    User(phoneNumber: "+79183981129")
                ]
            )
        }
    }

    func isAdmin() -> Bool {
        currentUser == tripDetail.admin
    }
}
