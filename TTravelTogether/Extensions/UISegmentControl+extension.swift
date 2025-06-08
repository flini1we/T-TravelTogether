import UIKit

extension UISegmentedControl {

    func setupTinkoffStyle() {

        backgroundColor = .clear
        selectedSegmentTintColor = .primaryYellow
        layer.borderWidth = 0
        setDividerImage(
            UIImage(),
            forLeftSegmentState: .normal,
            rightSegmentState: .normal,
            barMetrics: .default
        )
        setTitleTextAttributes([
            .foregroundColor: UIColor.black,
            .font: CustomFonts.default(FontValues.default.value).font
        ], for: .selected)
        setTitleTextAttributes([
            .foregroundColor: UIColor.secondaryLabel,
            .font: CustomFonts.default(FontValues.default.value).font
        ], for: .normal)
        selectedSegmentIndex = UISegmentedControl.noSegment
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 2
    }
}
