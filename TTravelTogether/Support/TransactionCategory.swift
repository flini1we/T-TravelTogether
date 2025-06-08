import UIKit

enum TransactionCategory: String, CaseIterable {

    case transport = "Транспорт"
    case accommodation = "Проживание"
    case food = "Питание"
    case entertainment = "Развлечения"
    case shopping = "Покупки"
    case health = "Здоровье"
    case communication = "Связь и интернет"
    case visaAndDocuments = "Виза и документы"
    case other = "Прочее"

    var getImage: UIImage {
        switch self {
        case .transport:
            return .transactionImageTransport
        case .accommodation:
            return .transactionImageAccommodation
        case .food:
            return .tIfood
        case .entertainment:
            return .tientertainment
        case .shopping:
            return .tishopping
        case .health:
            return .tihealth
        case .communication:
            return .ticommunication
        case .visaAndDocuments:
            return .tivisaAndDocuments
        case .other:
            return .tiother
        }
    }

    var camelValue: String {
        return "\(self)".uppercased()
    }

    static func fromCapsString(_ string: String) -> TransactionCategory {
        let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        switch trimmedString {
        case "TRANSPORT":
            return .transport
        case "ACCOMMODATION":
            return .accommodation
        case "FOOD":
            return .food
        case "ENTERTAINMENT":
            return .entertainment
        case "SHOPPING":
            return .shopping
        case "HEALTH":
            return .health
        case "COMMUNICATION":
            return .communication
        case "VISA_DOCUMENTS":
            return .visaAndDocuments
        default:
            return .other
        }
    }
}
