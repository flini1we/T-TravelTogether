import Foundation

struct TripDetailDTO: Codable {

    let title: String
    let price: Int
    let start: String
    let end: String
    let admin: User
    let members: [User]

    enum CodingKeys: String, CodingKey {
        case title = "name"
        case price = "totalBudget"
        case start = "dateOfBegin"
        case end = "dateOfEnd"
        case admin = "creator"
        case members = "participants"
    }
}
