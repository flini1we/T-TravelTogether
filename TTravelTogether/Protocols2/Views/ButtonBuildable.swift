import UIKit

protocol ButtonBuildable {

    func title(_ title: String) -> Self
    func backgroundColor(_ color: UIColor) -> Self
    func cornerRadius(_ cr: PaddingValues) -> Self
    func tintColor(_ color: UIColor) -> Self
    func build() -> UIButton
}
