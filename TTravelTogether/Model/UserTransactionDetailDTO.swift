import Foundation

struct UserTransactionDetailDTO: Codable, Hashable {

    let firstName: String
    let lastName: String
    let phoneNumber: String
    let shareAmount: Double
    let isRepaid: Bool
}
