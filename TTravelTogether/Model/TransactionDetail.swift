import Foundation

struct TransactionDetail {

    let id: Int
    let price: Double
    let description: String
    let category: TransactionCategory
    let participants: [UserTransactionDetailDTO]
    let creator: User
    let createdAt: String

    func wrapToDTO() -> TransactionDetailDTO {
        TransactionDetailDTO(
            id: self.id,
            price: self.price,
            description: self.description,
            createdAt: self.createdAt,
            category: self.category.camelValue,
            participants: self.participants,
            creator: self.creator)
    }
}
