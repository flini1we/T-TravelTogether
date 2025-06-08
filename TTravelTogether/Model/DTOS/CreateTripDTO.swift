import Foundation

struct CreateTripDTO: Codable {

    let title: String
    let price: Int
    let start: String
    let end: String
    let participants: [String]
}

extension CreateTripDTO {

    func convertToParams() -> [String: Any] {
        [
            "name": title,
            "totalBudget": price,
            "dateOfBegin": start,
            "dateOfEnd": end,
            "participantPhones": participants
        ]
    }
}
