import UIKit
import SkeletonView

extension UIView {

    func makeSkeletonable() {
        isSkeletonable = true
    }

    func setupDismiss() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
    }

    @objc private func dismiss() {
        endEditing(true)
    }

    func addShadow(
        opacity: Float = 0.25,
        offset: CGSize = CGSize(width: 0, height: 2),
        radius: CGFloat = 3,
        shouldRasterize: Bool = false
    ) {
        layer.shadowColor =
        ThemeManager.current == .dark
        ? UIColor.white.cgColor
        : UIColor.black.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shouldRasterize = shouldRasterize
        layer.rasterizationScale = UIScreen.main.scale
    }
}
