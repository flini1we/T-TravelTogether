import UIKit

final class ButtonBuilder {

    private var button: UIButton

    init() {
        self.button = UIButton()
    }

    func title(_ title: String) -> Self {
        button.setTitle(title, for: .normal)
        return self
    }

    func tintColor(_ color: UIColor) -> Self {
        button.tintColor = color
        return self
    }

    func cornerRadius(_ cr: PaddingValues) -> Self {
        button.layer.cornerRadius = cr.value
        return self
    }

    func textColor(_ color: UIColor) -> Self {
        button.titleLabel?.textColor = color
        return self
    }

    func build() -> UIButton {
        return button
    }
}
