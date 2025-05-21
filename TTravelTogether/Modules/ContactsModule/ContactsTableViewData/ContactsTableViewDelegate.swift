import UIKit

final class ContactsTableViewDelegate: NSObject, UITableViewDelegate {

    private(set) var viewModel: IContactsViewModel

    init(viewModel: IContactsViewModel) {
        self.viewModel = viewModel
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? ContactsTableViewCell,
              let contact = (tableView.dataSource as? UITableViewDiffableDataSource<Sections, Contact>)?.itemIdentifier(for: indexPath) else {
            return
        }

        if viewModel.selectedContacts.contains(contact) {
            cell.updateSelectionState(isSelected: false)
            viewModel.selectedContacts.remove(contact)
        } else {
            viewModel.selectedContacts.insert(contact)
            cell.updateSelectionState(isSelected: true)
        }

        tableView.deselectRow(at: indexPath, animated: false)
    }
}
