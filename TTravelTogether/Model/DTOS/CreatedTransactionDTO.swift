import Foundation

struct CreatedTransactionDTO: Codable {

    let price: Double
    let description: String
    let createdAt: String
    let category: String
    let participants: [CreatedTransactionMemberDTO]

    enum CodingKeys: String, CodingKey {
        case price = "totalCost"
        case description
        case createdAt
        case category
        case participants
    }
}
