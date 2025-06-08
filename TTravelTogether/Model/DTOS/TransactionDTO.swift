import Foundation

struct TransactionDTO: Identifiable, Codable {

    let id: Int
    let price: Int
    let description: String
    let createdAt: String
    let category: String

    enum CodingKeys: String, CodingKey {
        case id
        case price = "totalCost"
        case description
        case createdAt
        case category
    }

    static func unwrap(_ dtos: [TransactionDTO]) -> [Transaction] {
        dtos.map {
            Transaction(
                id: $0.id,
                price: $0.price,
                description: $0.description,
                createdAt: AppFormatter.shared.getDateRepresentationOfString($0.createdAt) ?? .now,
                category: TransactionCategory.fromCapsString($0.category)
            )
        }
    }
}
