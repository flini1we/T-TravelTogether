import Foundation

struct User: Hashable, Identifiable, Codable {

    let phoneNumber: String

    var id: String {
        phoneNumber
    }
}
