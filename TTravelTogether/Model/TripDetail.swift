import UIKit

struct TripDetail: Hashable, Identifiable, Codable {

    let id: UUID
    let admin: User
    let members: [User]

    func getMembersSequence() -> [User] {
        [admin] + members
    }

    static func getPlaceholder() -> Self {
        TripDetail(
            id: UUID(),
            admin: User(phoneNumber: "0"),
            members: [
                User(phoneNumber: "1"),
                User(phoneNumber: "2")
            ]
        )
    }
}
