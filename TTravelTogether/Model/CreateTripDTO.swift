import Foundation

struct CreateTripDTO: Codable {

    let title: String
    let price: Int
    let start: String
    let end: String
    let participants: [String]
}
