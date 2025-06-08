import Foundation

protocol NSNumberConvertible {
    var asNSNumber: NSNumber { get }
}

extension Int: NSNumberConvertible {
    var asNSNumber: NSNumber { NSNumber(value: self) }
}

extension Double: NSNumberConvertible {
    var asNSNumber: NSNumber { NSNumber(value: self) }
}

extension Float: NSNumberConvertible {
    var asNSNumber: NSNumber { NSNumber(value: self) }
}
