import Foundation

struct EditTripDTO: Codable {

    let id: Int
    let title: String
    let price: Int
    let start: String
    let end: String
    let admin: User
    let members: [User]

    enum CodingKeys: String, CodingKey {
        case id
        case title = "name"
        case price = "totalBudget"
        case start = "dateOfBegin"
        case end = "dateOfEnd"
        case admin = "creator"
        case members = "participants"
    }

    func convertToParams() -> [String: Any] {
        [
            "id": id,
            "name": title,
            "totalBudget": price,
            "dateOfBegin": start,
            "dateOfEnd": end,
            "participantPhones": members.compactMap({
                RussianValidationService.shared.invalidate(phone: $0.phoneNumber)
            })
        ]
    }

    static func convertToTripDetai(_ dto: EditTripDTO) -> TripDetail? {
        guard
            let startDate = AppFormatter.shared.getDateRepresentationOfString(dto.start),
            let endDate = AppFormatter.shared.getDateRepresentationOfString(dto.end)
        else {
            return nil
        }
        return TripDetail(
            id: dto.id,
            title: dto.title,
            price: dto.price,
            startsAt: startDate,
            finishAt: endDate,
            admin: dto.admin,
            members: dto.members
        )
    }
}
