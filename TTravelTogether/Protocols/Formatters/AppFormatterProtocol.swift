import UIKit

protocol AppFormatterProtocol {

    static var shared: AppFormatterProtocol { get }
    var dateFormatter: DateFormatter { get set }
    var numberFormatter: NumberFormatter { get set }

    func getStringRepresentationOfDate(from: Date) -> String
    func getValidNumberFromPrice(from: Int) -> String
}
