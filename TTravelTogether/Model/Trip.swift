import Foundation

struct Trip: Identifiable, Hashable, Codable {

    let id: Int
    let title: String
    let startsAt: Date
    let finishAt: Date
    let price: Int

    init(id: Int, title: String, startsAt: Date, finishAt: Date, price: Int) {
        self.id = id
        self.title = title
        self.startsAt = startsAt
        self.finishAt = finishAt
        self.price = price
    }
}
