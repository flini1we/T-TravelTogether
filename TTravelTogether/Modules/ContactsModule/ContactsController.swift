import UIKit

final class ContactsController: UIViewController {
    var onMembersUpdate: (([User]) -> Void)?
    lazy var onClearData = { [weak self] in
        self?.viewModel.clearData()
        self?.contactsView.contactTableView.reloadData()
    }

    private var contactsView: ContactsView {
        view as! ContactsView
    }
    private var viewModel: IContactsViewModel

    private var contactsDataSource: ContactsTableViewDataSource?
    private var contactsDelegate: ContactsTableViewDelegate?

    init(viewModel: IContactsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        super.loadView()

        view = ContactsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        onMembersUpdate?(viewModel.selectedContacts.map { User(phoneNumber: $0.phoneNumber) })
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ContactsController {

    func setup() {
        setupData()
        setupViewModelBindings()
        setupNavigationItem()
    }

    func setupData() {
        contactsDataSource = ContactsTableViewDataSource(viewModel: viewModel)
        contactsDataSource?.setupDataSource(
            with: contactsView.contactTableView,
            searchBar: contactsView.searchBar
        )
        contactsDelegate = ContactsTableViewDelegate(viewModel: viewModel)
        contactsView.contactTableView.delegate = contactsDelegate
    }

    func setupViewModelBindings() {

        viewModel.onRequestAccess = { [weak self] accessAlert in
            self?.present(accessAlert, animated: true)
        }
    }

    func setupNavigationItem() {
        navigationItem.titleView = ICloudNavTitle()

        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .done, primaryAction: UIAction { [weak self] _ in
            guard let self else { return }
            onMembersUpdate?(viewModel.selectedContacts.map { User(phoneNumber: $0.phoneNumber) })
            dismiss(animated: true)
        })
    }
}
