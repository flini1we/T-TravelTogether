import Foundation

struct Contact: Hashable, Identifiable {

    let id = UUID()
    let phoneNumber: String
    let firstName: String
    let secondName: String
}
