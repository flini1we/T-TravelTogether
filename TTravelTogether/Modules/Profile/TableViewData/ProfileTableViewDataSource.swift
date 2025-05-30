import UIKit

final class ProfileTableViewDataSource: NSObject, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ProfileScreenCellTypes.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as? ProfileTableViewCell
        else { return UITableViewCell() }
        let profileType = ProfileScreenCellTypes.allCases[indexPath.row]
        cell.setupWithData(profileType)
        return cell
    }
}
