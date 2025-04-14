import UIKit

final class ActivityIndicatorView: UIView {

    let spinningCircle = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ActivityIndicatorView {

    private func setup() {
        let size = UIElementsValues.activiryIndicator.value
        frame = .init(x: 0, y: 0, width: size, height: size)

        let rect = bounds
        let circularPath = UIBezierPath(ovalIn: rect)

        spinningCircle.path = circularPath.cgPath
        spinningCircle.fillColor = UIColor.clear.cgColor
        spinningCircle.strokeColor = UIColor.primaryYellow.cgColor
        spinningCircle.lineWidth = size / 10
        spinningCircle.strokeEnd = 0.33
        spinningCircle.lineCap = .round

        layer.addSublayer(spinningCircle)
    }

    func animate() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear) {
            self.transform = CGAffineTransform(rotationAngle: .pi)
        } completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear) {
                self.transform = .identity
            } completion: { _ in
                self.animate()
            }
        }
    }
}
