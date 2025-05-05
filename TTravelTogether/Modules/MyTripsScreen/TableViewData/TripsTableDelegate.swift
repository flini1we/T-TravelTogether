import UIKit

final class TripsTableDelegate: NSObject, UITableViewDelegate {
    var onTripDidSelect: ((UUID) -> Void)
    private var viewModel: MyTripsVMProtocol

    init(viewModel: MyTripsVMProtocol, completion: @escaping ((UUID) -> Void)) {
        self.viewModel = viewModel
        self.onTripDidSelect = completion
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)

        UIView.animateKeyframes(
            withDuration: 0.3,
            delay: 0,
            options: [.calculationModeLinear],
            animations: {
                UIView.addKeyframe(
                    withRelativeStartTime: 0,
                    relativeDuration: 0.6,
                    animations: {
                        cell?.transform = CGAffineTransform(scaleX: 0.875, y: 0.875)
                    }
                )

                UIView.addKeyframe(
                    withRelativeStartTime: 0.6,
                    relativeDuration: 0.4,
                    animations: {
                        cell?.transform = .identity
                    }
                )
            },
            completion: { _ in
                self.onTripDidSelect(self.viewModel.tripsData[indexPath.row].id)
            }
        )
    }
}
