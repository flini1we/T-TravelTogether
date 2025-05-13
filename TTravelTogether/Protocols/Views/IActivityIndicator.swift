import UIKit

protocol IActivityIndicator: UIView {

    var spinningCircle: CAShapeLayer { get }

    func animate()
}
