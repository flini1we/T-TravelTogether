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
}
