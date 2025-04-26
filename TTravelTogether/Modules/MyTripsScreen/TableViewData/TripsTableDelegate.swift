import UIKit

final class TripsTableDelegate: NSObject, UITableViewDelegate {

    private var viewModel: MyTripsVMProtocol
    private var coordinator: CoordinatorProtocol?

    init(viewModel: MyTripsVMProtocol, coordinator: CoordinatorProtocol?) {
        self.viewModel = viewModel
        self.coordinator = coordinator
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
                self.coordinator?.showTripDetail(self.viewModel.tripsData[indexPath.row].id)
            }
        )
    }
}
