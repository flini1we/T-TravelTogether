import UIKit

final class AppFormatter: IAppFormatter {

    static var shared: IAppFormatter = AppFormatter()

    private init() { }

    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        formatter.locale = .current
        return formatter
    }()

    var isoDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = .current
        return formatter
    }()

    var iso8601DataFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        return formatter
    }()

    func getStringRepresentationOfDate(from date: Date) -> String {
        dateFormatter.string(from: date)
    }

    func getValidNumberFromPrice(from price: NSNumberConvertible) -> String {
        numberFormatter.string(from: price.asNSNumber) ?? "NAN"
    }

    func getStringRepresentationOfDateISO(_ date: Date) -> String {
        isoDateFormatter.string(from: date)
    }

    func getDateRepresentationOfString(_ date: String) -> Date? {
        isoDateFormatter.date(from: date)
    }

    func getStringRepresentationOfDateISO8601(_ date: Date) -> String {
        iso8601DataFormatter.string(from: date)
    }
}
