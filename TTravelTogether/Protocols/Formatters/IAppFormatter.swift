import UIKit

protocol IAppFormatter {

    static var shared: IAppFormatter { get }
    var dateFormatter: DateFormatter { get set }
    var numberFormatter: NumberFormatter { get set }

    func getStringRepresentationOfDate(from: Date) -> String
    func getValidNumberFromPrice(from: NSNumberConvertible) -> String
    func getStringRepresentationOfDateISO(_ date: Date) -> String
    func getDateRepresentationOfString(_ date: String) -> Date?
    func getStringRepresentationOfDateISO8601(_ date: Date) -> String
}
