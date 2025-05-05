import UIKit
import SnapKit
import SkeletonView

final class ButtonBuilder: IButtonBuilder {

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

    func makeSkeletonable() -> Self {
        button.isSkeletonable = true
        return self
    }

    func font(_ font: UIFont) -> Self {
        button.titleLabel?.font = font
        return self
    }

    func deactivate() -> Self {
        button.alpha = 0.5
        button.isEnabled = false
        return self
    }

    func disableContentEdgesInsets() -> Self {
        if var config = button.configuration {
            config.contentInsets = .zero
            button.configuration = config
        }
        return self
    }

    func build() -> UIButton {
        return button
    }
}
