import UIKit
import Combine

final class PaymentMembersDataSource: NSObject {
    var onPriceUpdate: ((UserPayable, Double) -> Void)?

    private var dataSource: UITableViewDiffableDataSource<Sections, UserPayable>?
    private var cancellables: Set<AnyCancellable> = []

    func setupDataSource(with data: [UserPayable], tableView: UITableView) {
        dataSource = UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { [weak self] tableView, indexPath, userPayable in
                guard let self, let cell = tableView.dequeueReusableCell(
                    withIdentifier: PaymentMemberTableViewCell.identifier,
                    for: indexPath)
                        as? PaymentMemberTableViewCell
                else { return UITableViewCell() }
                cell.setupWithUser(userPayable)
                cell.priceTextField
                    .textPublisher
                    .sink { [weak self] price in
                        guard let self, let price = Double(price) else { return }
                        onPriceUpdate?(userPayable, price)
                    }
                    .store(in: &cancellables)
                return cell
            }
        )
        dataSource?.defaultRowAnimation = .fade
        applyFreshSnaphot(data: data, animated: true)
    }

    func updateData(data: [UserPayable]) {
        applyFreshSnaphot(data: data, animated: false)
    }
}

private extension PaymentMembersDataSource {

    func applyFreshSnaphot(data: [UserPayable], animated: Bool) {
        var snaphot = NSDiffableDataSourceSnapshot<Sections, UserPayable>()
        snaphot.appendSections([.main])
        snaphot.appendItems(data)
        dataSource?.apply(snaphot, animatingDifferences: animated)
    }
}
