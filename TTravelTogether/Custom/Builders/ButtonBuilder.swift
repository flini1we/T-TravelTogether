import UIKit
import SnapKit

final class ButtonBuilder {

    private var button: UIButton

    init() {
        self.button = UIButton(configuration: .plain())
        button.snp.makeConstraints { make in
            make.height.equalTo(UIElementsValues.buttonHeight.value)
        }
    }

    func title(_ title: String) -> Self {
        button.setTitle(title, for: .normal)
        return self
    }

    func backgroundColor(_ color: UIColor) -> Self {
        button.backgroundColor = color
        return self
    }

    func cornerRadius(_ cr: PaddingValues) -> Self {
        button.layer.cornerRadius = cr.value
        return self
    }

    func tintColor(_ color: UIColor) -> Self {
        button.tintColor = color
        return self
    }

    func build() -> UIButton {
        return button
    }
}
