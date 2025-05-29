import UIKit

struct TripDetail: Hashable, Identifiable, Codable {

    let id: Int?
    let title: String
    let price: Int
    let startsAt: Date
    let finishAt: Date
    let admin: User
    let members: [User]

    init(
        id: Int?,
        title: String,
        price: Int,
        startsAt: Date,
        finishAt: Date,
        admin: User,
        members: [User]
    ) {
        self.id = id
        self.title = title
        self.price = price
        self.startsAt = startsAt
        self.finishAt = finishAt
        self.admin = admin
        self.members = members
    }

    func getMembersSequence() -> [User] {
        [admin] + members
    }

    static func fake() -> Self {
        TripDetail(
            id: nil,
            title: .AppStrings.AppTitles.tripDetailTitle,
            price: .AppIntegers.tripPricePlaceholder,
            startsAt: .now,
            finishAt: .now,
            admin: User(name: "admin", lastName: "", phoneNumber: "0"),
            members: [
                User(name: "user", lastName: "", phoneNumber: "1"),
                User(name: "user", lastName: "", phoneNumber: "2")
            ]
        )
    }
}
