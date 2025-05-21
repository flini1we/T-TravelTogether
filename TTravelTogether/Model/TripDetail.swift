import UIKit

struct TripDetail: Hashable, Identifiable, Codable {

    let id: UUID
    let title: String
    let price: Int
    let startsAt: Date
    let finishAt: Date
    let admin: User
    let members: [User]

    func getMembersSequence() -> [User] {
        [admin] + members
    }

    static func fake() -> Self {
        TripDetail(
            id: UUID(),
            title: .AppStrings.AppTitles.tripDetailTitle,
            price: .AppIntegers.tripPricePlaceholder,
            startsAt: .now,
            finishAt: .now,
            admin: User(phoneNumber: "0"),
            members: [
                User(phoneNumber: "1"),
                User(phoneNumber: "2")
            ]
        )
    }
}
