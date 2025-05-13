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
        let cell = tableView.dequeueReusableCell(withIdentifier: TripTableViewCell.identifier, for: indexPath) as! TripTableViewCell
        let travel = trips[indexPath.row]
        _ = tableView.isSkeletonable ? cell.bgView.showAnimatedGradientSkeleton()
                                     : cell.setupWithTravel(travel)
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
/*
 final class TripsTableDataSource: NSObject {
 
 private var viewModel: IMyTripsViewModel
 var dataSource: UITableViewDiffableDataSource<Sections, Trip>?
 
 init(viewModel: IMyTripsViewModel) {
 self.viewModel = viewModel
 }
 
 func setupDataSource(with tableView: UITableView) {
 dataSource = UITableViewDiffableDataSource(
 tableView: tableView,
 cellProvider: { [weak self] tableView, indexPath, travel in
 guard let self else { return UITableViewCell() }
 let cell = tableView.dequeueReusableCell(withIdentifier: TripTableViewCell.identifier, for: indexPath) as! TripTableViewCell
 let travel = viewModel.tripsData.value[indexPath.row]
 cell.setupWithTravel(travel)
 return cell
 }
 )
 applyFreshSnapshot(data: viewModel.tripsData.value)
 }
 
 func applyFreshSnapshot(data: [Trip]) {
 var snaphot = NSDiffableDataSourceSnapshot<Sections, Trip>()
 
 snaphot.appendSections([.main])
 snaphot.appendItems(data)
 
 dataSource?.apply(snaphot, animatingDifferences: true)
 }
 }
 */
