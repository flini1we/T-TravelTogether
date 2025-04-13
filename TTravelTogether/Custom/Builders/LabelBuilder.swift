import UIKit

final class LabelBuilder {

    private lazy var label: UILabel = {
        UILabel()
    }()

    func textColor(_ color: UIColor) -> Self {
        label.textColor = color
        return self
    }

    func text(_ text: String) -> Self {
        label.text = text
        return self
    }

    func font(_ font: UIFont) -> Self {
        label.font = font
        return self
    }

    func build() -> UILabel {
        label
    }
}
