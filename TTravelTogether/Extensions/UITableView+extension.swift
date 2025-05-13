import UIKit

extension UITableView {

    func showSkeleton() {
        isSkeletonable = true
        showAnimatedGradientSkeleton()
        showSkeleton(transition: .crossDissolve(0.25))
    }

    func hideSkeleton() {
        isSkeletonable = false
        hideSkeleton(transition: .crossDissolve(0.25))
    }
}
