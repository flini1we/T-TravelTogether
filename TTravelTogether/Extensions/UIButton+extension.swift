import UIKit

extension UIButton {

    func addPressAnimation(completion: (() -> Void)? = nil) {
        addAction(UIAction { [weak self] _ in
            self?.animatePress(completion: completion)
        }, for: .touchUpInside)
    }

    private func animatePress(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { _ in
            UIView.animate(withDuration: 0.15, animations: {
                self.transform = .identity
            }, completion: { _ in
                completion?()
            })
        })
    }

    func changeActivision(_ isActive: Bool) {
        alpha = isActive ? 1 : 0.5
        isEnabled = isActive ? true: false
    }
}
