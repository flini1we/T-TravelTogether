import Foundation

struct User: Hashable, Identifiable, Codable {

    let name: String
    let lastName: String
    let phoneNumber: String

    init(name: String = "", lastName: String = "", phoneNumber: String) {
        self.name = name
        self.lastName = lastName
        self.phoneNumber = phoneNumber
    }

    var id: String {
        phoneNumber
    }
}
