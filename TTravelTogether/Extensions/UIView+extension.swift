import UIKit

extension UIView {

    func setupDismiss() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
    }

    @objc private func dismiss() {
        endEditing(true)
    }
}
