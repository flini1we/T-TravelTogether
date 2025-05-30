import UIKit

final class ProfileTableViewDelegate: NSObject, UITableViewDelegate {
    private var onProfileLeaving: (() -> Void)

    init(onProfileLeaving: @escaping (() -> Void)) {
        self.onProfileLeaving = onProfileLeaving
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = .zero
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = ProfileScreenCellTypes.allCases[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        switch selectedItem {
        case .leave:
            onProfileLeaving()
        default:
            break
        }
    }
}
