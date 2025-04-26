import Foundation

struct Trip: Identifiable, Hashable, Codable {

    let id: UUID
    let title: String
    let startsAt: Date
    let finishAt: Date
    let price: Int

    init(id: UUID = UUID(), title: String, startsAt: Date, finishAt: Date, price: Int) {
        self.id = id
        self.title = title
        self.startsAt = startsAt
        self.finishAt = finishAt
        self.price = price
    }
}

extension Trip {
    static func obtainMock() -> [Self] {
        [
            .init(title: "Сочи", startsAt: .now, finishAt: .now, price: 1000000),
            .init(title: "London", startsAt: .now, finishAt: .now, price: 969830),
            .init(title: "Saint-P", startsAt: .now, finishAt: .now, price: 1189890)
        ]
    }
}
