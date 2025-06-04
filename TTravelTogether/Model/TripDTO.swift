import Foundation

struct TripDTO: Codable {

    let id: Int
    let title: String
    let startsAt: String
    let finishAt: String
    let price: Int

    enum CodingKeys: String, CodingKey {
        case id
        case title = "name"
        case startsAt = "dateOfBegin"
        case finishAt = "dateOfEnd"
        case price = "totalBudget"
    }
}
