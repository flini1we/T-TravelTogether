import Foundation

struct Transaction: Identifiable {

    let id: Int
    let price: Int
    let description: String
    let createdAt: Date
    let category: TransactionCategory
}
