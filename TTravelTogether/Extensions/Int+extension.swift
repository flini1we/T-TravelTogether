import Foundation

extension Int {

    enum AppIntegers {
        static let passwordMinLength = 6
        static let passwordMaxLength = 15
        static let tripPricePlaceholder = 777777
    }

    var getSize: CGSize {
        CGSize(width: self, height: self)
    }
}
