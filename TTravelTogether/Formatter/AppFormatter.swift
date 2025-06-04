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

    func getValidNumberFromPrice(from price: Int) -> String {
        numberFormatter.string(from: NSNumber(value: price)) ?? "NAN"
    }

    func getStringRepresentationOfDateISO(_ date: Date) -> String {
        isoDateFormatter.string(from: date)
    }

    func getDateRepresentationOfString(_ date: String) -> Date? {
        isoDateFormatter.date(from: date)
    }
}
