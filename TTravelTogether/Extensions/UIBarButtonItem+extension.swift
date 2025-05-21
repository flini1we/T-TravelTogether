import UIKit

extension UIBarButtonItem {

    func setEnabled(_ enabled: Bool, disabledColor: UIColor = .gray, enableColor: UIColor? = nil) {
        isEnabled = enabled
        tintColor = enabled ? enableColor : disabledColor
    }
}
