import UIKit
import SkeletonView

final class TransactionsTableViewDataSource: NSObject, UITableViewDataSource {

    private var data: [Transaction]
    private weak var table: UITableView?

    init(data: [Transaction], table: UITableView) {
        self.data = data
        self.table = table
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier, for: indexPath) as? TransactionTableViewCell
        else { return UITableViewCell() }
        cell.setupWithTransaction(data[indexPath.row])
        return cell
    }

    func updateData(_ data: [Transaction]) {
        self.data = data
        table?.reloadData()
    }
}

extension TransactionsTableViewDataSource: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        TransactionTableViewCell.identifier
    }
}
