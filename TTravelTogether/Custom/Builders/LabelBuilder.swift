import UIKit
import SkeletonView

final class LabelBuilder: LabelBuildable {

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

    func makeSkeletonable() -> Self {
        label.isSkeletonable = true
        return self
    }

    func skeletonTextLineHeight(_ height: SkeletonTextLineHeight) -> Self {
        guard label.isSkeletonable else { return self }
        label.skeletonTextLineHeight = height
        return self
    }

    func skeletonLinesCornerRadius(_ value: CGFloat) -> Self {
        guard label.isSkeletonable else { return self }
        label.linesCornerRadius = Int(value)
        return self
    }

    func build() -> UILabel {
        label
    }
}
