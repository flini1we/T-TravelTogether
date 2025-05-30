import UIKit
import Combine
import Contacts
import ContactsUI

final class CreateTripController: UIViewController {
    var coordinator: IMainCoordinator?
    var onDisappear: (() -> Void)?
    var onTripCreating: (() -> Void)?
    var onTripEditing: ((TripDetail) -> Void)?
    var onIncorrectPriceAlertDidSet: ((UIAlertController) -> Void)?

    private(set) var viewModel: ICreateTripViewModel
    private var createTripView: ICreateTripView {
        view as! ICreateTripView
    }
    private var tripMembersCollectionViewDataSource: TripMembersCollectionViewDataSource?
    private var cancellables: Set<AnyCancellable> = []
    private lazy var createTripAction: UIAction = {
        return UIAction { [weak self] _ in
            guard let self else { return }
            if viewModel.isEditing() {
                viewModel.updateTrip { [weak self] result in
                    switch result {
                    case .success(let tripDetailDTO):
                        guard let tripDetail = EditTripDTO.convertToTripDetai(tripDetailDTO) else {
                            self?.present(
                                AlertFactory.createErrorAlert(message: .AppStrings.Errors.errorToConvertData),
                                animated: true
                            )
                            return
                        }
                        self?.onTripEditing?(tripDetail)
                        self?.dismiss(animated: true)
                    case .failure(let error):
                        self?.present(AlertFactory.createErrorAlert(message: error.message), animated: true)
                    }
                }
            } else {
                viewModel.createTrip(dates: createTripView.getTripDates()) { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success(let createdTrip):
                        viewModel.createdTrip = createdTrip
                    case .failure(let failure):
                        present(
                            AlertFactory.createErrorAlert(message: failure.message),
                            animated: true
                        )
                    }
                }
            }
        }
    }()

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

    func setupEditedTrip(_ editedTrip: TripDetail, ogId: Int) {
        viewModel.ogId = ogId
        viewModel.editedTrip = editedTrip
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit { NotificationCenter.default.removeObserver(self) }
}

private extension CreateTripController {

    func setup() {
        setupFields()
        setupActions()
        setupBindings()
        setupNotification()
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

    func setupActions() {
        createTripView.addCreateTripAction(createTripAction)
    }

    func setupBindings() {
        setupViewModelBindings()
        setupViewBindings()
    }

    func setupViewModelBindings() {
        viewModel.onDataHandling = { [weak self] in
            self?.createTripView.getTripDates()
        }

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

    func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateColor(_:)),
            name: NSNotification.Name(.AppStrings.Notification.changeTheme),
            object: nil
        )
    }

    @objc private func updateColor(_ notification: NSNotification) {
        guard
            let currentColor = notification.userInfo?[String.AppStrings.Notification.updatedThemeKey] as? AppTheme
        else { return }
        createTripView.updateTheme(currentColor)
    }
}
