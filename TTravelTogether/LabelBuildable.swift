import UIKit

protocol LabelBuildable {

    func textColor(_ color: UIColor) -> Self
    func text(_ text: String) -> Self
    func font(_ font: UIFont) -> Self
    func build() -> UILabel
}
