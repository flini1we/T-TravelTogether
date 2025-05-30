import UIKit

extension UILabel {

    static func showTitleLabel(_ string: String) -> UILabel {
        LabelBuilder()
            .font(CustomFonts.bold(FontValues.big.value).font)
            .textColor(.label)
            .text(string)
            .build()
    }
}
