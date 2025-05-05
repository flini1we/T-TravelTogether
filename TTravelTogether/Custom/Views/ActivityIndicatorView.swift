import UIKit

final class ActivityIndicatorView: UIView, ActivityIndicatorProtocol {

    let spinningCircle = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func animate() {
        animateRotation(to: .pi) {
            self.animateRotation(to: 0) {
                self.animate()
            }
        }
    }
}

private extension ActivityIndicatorView {

    enum ActivityIndicatorConstants {
        static let sctrokeEnd: CGFloat = 0.33
    }

    func setup() {
        let size = UIElementsValues.activiryIndicator.value
        frame = CGRect(x: 0, y: 0, width: size, height: size)

        let rect = bounds
        let circularPath = UIBezierPath(ovalIn: rect)

        spinningCircle.path = circularPath.cgPath
        spinningCircle.fillColor = UIColor.clear.cgColor
        spinningCircle.strokeColor = UIColor.primaryYellow.cgColor
        spinningCircle.lineWidth = size / 10
        spinningCircle.strokeEnd = ActivityIndicatorConstants.sctrokeEnd
        spinningCircle.lineCap = .round

        layer.addSublayer(spinningCircle)
    }

    func animateRotation(to angle: CGFloat, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear) {
            self.transform = CGAffineTransform(rotationAngle: angle)
        } completion: { _ in completion() }
    }
}
