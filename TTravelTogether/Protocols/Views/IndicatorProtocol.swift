import UIKit

protocol ActivityIndicatorProtocol: UIView {

    var spinningCircle: CAShapeLayer { get }

    func animate()
}
