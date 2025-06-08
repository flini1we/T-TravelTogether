import Foundation

struct UserDTO: Hashable, Identifiable, Codable {

    let name: String
    let lastName: String
    let phoneNumber: String
    let password: String
    let passwordConfirmation: String

    var id: String {
        phoneNumber
    }
}
