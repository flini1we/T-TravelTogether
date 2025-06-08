import UIKit

final class DebtTableViewDataSource: NSObject {
    var dataSource: UITableViewDiffableDataSource<Sections, UserTransactionDetailDTO>?
    var currentUser: User

    init(currentUser: User) {
        self.currentUser = currentUser
    }

    func setupDataSource(with tableView: UITableView, data: [UserTransactionDetailDTO]) {
        dataSource?.defaultRowAnimation = .fade
        dataSource = UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { [weak self] tableView, indexPath, debt in
                guard let self, let cell = tableView.dequeueReusableCell(
                    withIdentifier: DebtTableViewCell.identifier,
                    for: indexPath
                )
                as? DebtTableViewCell
                else { return UITableViewCell() }
                cell.setupWithDebt(debt, isCurrentUser: currentUser.phoneNumber == debt.phoneNumber)
                return cell
            }
        )
        applyFreshSnaphot(data: data)
    }

    func updateData(data: [UserTransactionDetailDTO]) {
        applyFreshSnaphot(data: data)
    }
}

private extension DebtTableViewDataSource {

    func applyFreshSnaphot(data: [UserTransactionDetailDTO]) {
        var snapshot = NSDiffableDataSourceSnapshot<Sections, UserTransactionDetailDTO>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        dataSource?.apply(snapshot)
    }
}
