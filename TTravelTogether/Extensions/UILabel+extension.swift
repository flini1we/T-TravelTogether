import UIKit

// TODO: cover into factory
extension UILabel {

    static func showTitleLabel(_ string: String, size: FontValues) -> UILabel {
        LabelBuilder()
            .font(CustomFonts.bold(size.value).font)
            .textColor(.label)
            .text(string)
            .build()
    }

    static func showHeaderLabel(_ string: String, size: FontValues, color: UIColor = .label) -> UILabel {
        LabelBuilder()
            .font(CustomFonts.medium(size.value).font)
            .text(string)
            .textColor(color)
            .build()
    }
}
