import Foundation

struct TransactionDetailDTO: Codable {

    let id: Int
    let price: Double
    let description: String
    let createdAt: String
    let category: String
    let participants: [UserTransactionDetailDTO]
    let creator: User

    enum CodingKeys: String, CodingKey {
        case id
        case price = "totalCost"
        case description
        case createdAt
        case category
        case participants
        case creator
    }

    func wrapToTransactionDetail() -> TransactionDetail {
        TransactionDetail(
            id: id,
            price: price,
            description: description,
            category: TransactionCategory.fromCapsString(category),
            participants: participants,
            creator: creator,
            createdAt: createdAt
        )
    }
}
