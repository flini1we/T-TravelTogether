import UIKit
import Combine
import Contacts
import ContactsUI

final class CreateTripController: UIViewController {
    var coordinator: IMainCoordinator?
    var onDisappear: (() -> Void)?
    var onTripCreating: (() -> Void)?
    var onIncorrectPriceAlertDidSet: ((UIAlertController) -> Void)?

    private(set) var viewModel: ICreateTripViewModel
    private var createTripView: ICreateTripView {
        view as! ICreateTripView
    }
    private var tripMembersCollectionViewDataSource: TripMembersCollectionViewDataSource?
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: ICreateTripViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        super.loadView()
        view = CreateTripView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        clearData()
    }

    func obtainContacts() -> [Contact] {
        viewModel.obtainContacts()
    }

    func updateMembersAfterSelection(_ selectedMembers: [User]) {
        viewModel.updateMembers(users: selectedMembers)
    }

    func setupEditedTrip(_ editedTrip: TripDetail) {
        viewModel.editedTrip = editedTrip
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CreateTripController {

    func setup() {
        setupFields()
        setupBindings()
    }

    func setupFields() {
        createTripView.onShowingContacts = { [weak self] in
            self?.requestContactsAccess()
        }
        tripMembersCollectionViewDataSource = TripMembersCollectionViewDataSource(data: viewModel.tripMembers, collectionView: createTripView.tripMemebersCollectionView)
        createTripView.tripMemebersCollectionView.dataSource = tripMembersCollectionViewDataSource
        viewModel.onClearingController = { [weak self] in
            self?.createTripView.tripTitleField.text = ""
            self?.createTripView.tripPriceField.text = ""
        }
    }

    func setupBindings() {
        setupViewModelBindings()
        setupViewBindings()
    }

    func setupViewModelBindings() {

        viewModel.isCreateButtonEnablePublisher
            .assign(to: \.isEnabled, on: createTripView.createButton)
            .store(in: &cancellables)

        viewModel.isCreateButtonEnablePublisher
            .sink { [weak self] isValid in
                self?.createTripView.createButton.alpha = isValid ? 1 : 0.5
            }
            .store(in: &cancellables)

        viewModel.tripMembersPublisher
            .sink { [weak self] members in
                guard let self else { return }
                updateDataSource(with: members)
            }
            .store(in: &cancellables)

        viewModel.createdTripPublisher
            .dropFirst()
            .sink { [weak self] _ in
                guard let self else { return }
                dismiss(animated: true)
                onTripCreating?()
            }
            .store(in: &cancellables)

        viewModel.editedTripPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] editedTrip in
                guard let self, let editedTrip else { return }
                createTripView.setupWithEditedTrip(tripDetail: editedTrip)
                updateDataSource(with: editedTrip.getMembersSequence())
                viewModel.tripTitleText = editedTrip.title
                viewModel.tripPriceText = "\(editedTrip.price)"
            }
            .store(in: &cancellables)
        viewModel.onShowingIncorrectPriceAlert = { [weak self] alert in
            self?.onIncorrectPriceAlertDidSet?(alert)
        }
    }

    func setupViewBindings() {

        createTripView.tripTitleField.textPublisher
            .assign(to: \.tripTitleText, on: viewModel)
            .store(in: &cancellables)

        createTripView.tripPriceField.textPublisher
            .assign(to: \.tripPriceText, on: viewModel)
            .store(in: &cancellables)

        createTripView.onCreatingTrip = { [weak self] in
            guard let self else { return }
            viewModel.createTrip(dates: createTripView.getTripDates())
        }
    }

    func requestContactsAccess() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, _ in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                if granted {
                    coordinator?.showContactList()
                } else {
                    let contactAccessAlert = AlertFactory.createContactsAccessAlert {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    } onCancel: { }
                    present(contactAccessAlert, animated: true)
                }
            }
        }
    }

    func updateDataSource(with data: [User]) {
        tripMembersCollectionViewDataSource?.updateUsers(data: data)
    }

    func clearData() {
        viewModel.clearData()
        tripMembersCollectionViewDataSource?.updateUsers(data: viewModel.tripMembers)
        onDisappear?()
    }
}
