import UIKit
import SkeletonView

protocol ILabelBuilder {

    func textColor(_ color: UIColor) -> Self
    func text(_ text: String) -> Self
    func font(_ font: UIFont) -> Self
    func makeSkeletonable() -> Self
    func skeletonTextLineHeight(_ height: SkeletonTextLineHeight) -> Self
    func skeletonLinesCornerRadius(_ value: CGFloat) -> Self
    func build() -> UILabel
}
