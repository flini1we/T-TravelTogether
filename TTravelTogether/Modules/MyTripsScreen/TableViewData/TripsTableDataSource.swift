import UIKit

final class TripsTableDataSource: NSObject {

    private var viewModel: MyTripsVMProtocol
    var dataSource: UITableViewDiffableDataSource<Sections, Trip>?

    init(viewModel: MyTripsVMProtocol) {
        self.viewModel = viewModel
    }

    func setupDataSource(with tableView: UITableView) {
        dataSource = UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { [weak self] tableView, indexPath, travel in
                guard let self else { return UITableViewCell() }
                let cell = tableView.dequeueReusableCell(withIdentifier: TripTableViewCell.identifier, for: indexPath) as! TripTableViewCell
                let travel = viewModel.tripsData[indexPath.row]
                cell.setupWithTravel(travel)
                return cell
            }
        )
        applyFreshSnapshot(data: viewModel.tripsData)
    }

    func applyFreshSnapshot(data: [Trip]) {
        var snaphot = NSDiffableDataSourceSnapshot<Sections, Trip>()

        snaphot.appendSections([.main])
        snaphot.appendItems(data)

        dataSource?.apply(snaphot, animatingDifferences: false)
    }
}
