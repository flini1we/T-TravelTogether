import UIKit
import Contacts
import Combine

final class ContactsTableViewDataSource: NSObject {

    private var dataSource: UITableViewDiffableDataSource<Sections, Contact>?
    private var viewModel: IContactsViewModel
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: IContactsViewModel) {
        self.viewModel = viewModel
    }

    func setupDataSource(with tableView: UITableView, searchBar: UISearchBar) {
        configureDataSource(for: tableView)
        searchBar.delegate = self

        viewModel.contacts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applyFreshSnapshot(data: self?.viewModel.contacts.value ?? [])
            }
            .store(in: &cancellables)
    }

    private func configureDataSource(for tableView: UITableView) {
        dataSource = UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { [weak self] tableView, indexPath, contact in
                guard let self else { return UITableViewCell() }
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: ContactsTableViewCell.identifier,
                    for: indexPath
                ) as? ContactsTableViewCell else { return UITableViewCell() }
                cell.setupWithUser(contact, alreadySelected: viewModel.isContactSelected(contact))
                return cell
            }
        )
    }

    private func applyFreshSnapshot(data: [Contact]) {
        var snapshot = NSDiffableDataSourceSnapshot<Sections, Contact>()

        snapshot.appendSections([.main])
        snapshot.appendItems(data)

        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension ContactsTableViewDataSource: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filtered = viewModel.contacts.value.filter {
            searchText.isEmpty ||
            $0.firstName.localizedCaseInsensitiveContains(searchText) ||
            $0.secondName.localizedCaseInsensitiveContains(searchText) ||
            $0.phoneNumber.contains(searchText)
        }
        applyFreshSnapshot(data: filtered)
    }
}
