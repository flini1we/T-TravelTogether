import UIKit

final class AppFormatter: AppFormatterProtocol {

    static var shared: AppFormatterProtocol = AppFormatter()

    private init() { }

    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
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
}
