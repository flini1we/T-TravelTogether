import Foundation

struct UserPayable: Hashable, Identifiable, Codable {

    let name: String
    let lastName: String
    let phoneNumber: String
    let price: Double
    let isPriceEditable: Bool

    var id: String {
        phoneNumber
    }

    enum CodingKeys: String, CodingKey {
        case name = "firstName"
        case lastName = "lastName"
        case phoneNumber
    }

    init(name: String, lastName: String, phoneNumber: String, price: Double, isPriceEditable: Bool) {
        self.name = name
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.price = price
        self.isPriceEditable = isPriceEditable
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        lastName = try container.decode(String.self, forKey: .lastName)
        phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        isPriceEditable = false
        price = 0
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(phoneNumber, forKey: .phoneNumber)
    }

    static func wrapToCreatedTransactionMemberDTO(_ data: [Self]) -> [CreatedTransactionMemberDTO] {
        data.map {
            CreatedTransactionMemberDTO(
                phoneNumber: RussianValidationService.shared.invalidate(phone: $0.phoneNumber),
                shareAmount: $0.price)
        }
    }
}
