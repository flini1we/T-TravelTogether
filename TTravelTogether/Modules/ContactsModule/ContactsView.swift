import UIKit

final class ContactsView: UIView {

    private(set) lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = .AppStrings.Contacts.contactsSearchBarTitle
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        searchBar.snp.makeConstraints { make in
            make.height.equalTo(UIElementsValues.searchBar.value)
        }
        return searchBar
    }()

    private(set) lazy var contactTableView: UITableView = {
        let table = UITableView()
        table.keyboardDismissMode = .onDrag
        table.register(ContactsTableViewCell.self, forCellReuseIdentifier: ContactsTableViewCell.identifier)
        return table
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ContactsView {

    func setup() {
        backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }

    func setupSubviews() {
        addSubview(searchBar)
        addSubview(contactTableView)
    }

    func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(PaddingValues.small.value)
            make.top.equalToSuperview().inset(PaddingValues.large.value)
        }

        contactTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(PaddingValues.small.value)
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
}
