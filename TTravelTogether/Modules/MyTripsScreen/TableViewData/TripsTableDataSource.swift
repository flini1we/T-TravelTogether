import UIKit
import SkeletonView
import Combine

final class TripsTableDataSource: NSObject, UITableViewDataSource {

    private var trips: [Trip]
    private weak var tableView: UITableView?

    init(trips: [Trip], tableView: UITableView) {
        self.trips = trips
        self.tableView = tableView
        super.init()
    }

    func update(_ trips: [Trip]) {
        self.trips = trips
        withAnimation {
            self.tableView?.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trips.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TripTableViewCell.identifier, for: indexPath) as? TripTableViewCell else { return UITableViewCell() }
        let travel = trips[indexPath.row]
        cell.setupWithTravel(travel)
        return cell
    }
}

extension TripsTableDataSource: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        TripTableViewCell.identifier
    }
}

private extension TripsTableDataSource {

    func withAnimation(_ completion: @escaping (() -> Void)) {
        guard let tableView else { return }
        UIView.transition(
            with: tableView,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {
                completion()
            },
            completion: nil)
    }
}
