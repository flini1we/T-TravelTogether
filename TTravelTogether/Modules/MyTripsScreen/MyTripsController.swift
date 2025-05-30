import UIKit
import Combine

final class MyTripsController: UIViewController {
    weak var coordinator: IMainCoordinator?

    private var myTripsView: MyTripsView {
        view as! MyTripsView
    }
    private let viewModel: IMyTripsViewModel
    private var tableViewDataSource: TripsTableDataSource?
    private var tableViewDelegate: TripsTableDelegate?
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: IMyTripsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        super.loadView()

        view = MyTripsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNotification()
    }

    func updateTrips() {
        viewModel.loadData()
    }

    deinit { NotificationCenter.default.removeObserver(self) }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MyTripsController {

    func setup() {
        myTripsView.onTableViewRefresh = { [weak self] in
            self?.viewModel.loadData()
        }
        myTripsView.travellingsTableView.makeSkeletonable()
        setupDataSource()
        setupDelegate()
        setupBindings()
    }

    func setupDataSource() {
        tableViewDataSource = TripsTableDataSource(
            trips: viewModel.tripsData,
            tableView: myTripsView.travellingsTableView
        )
        myTripsView.travellingsTableView.dataSource = tableViewDataSource
    }

    func setupDelegate() {
        tableViewDelegate = TripsTableDelegate(viewModel: viewModel) { [weak self] tripId in
            self?.coordinator?.showTripDetail(tripId)
        }
        myTripsView.travellingsTableView.delegate = tableViewDelegate
    }

    func setupBindings() {
        viewModel
            .isLoadingDataPublisher
            .sink { [weak self] isLoading in
                guard let self else { return }
                if isLoading {
                    myTripsView.travellingsTableView.showSkeleton()
                } else {
                    myTripsView.travellingsTableView.hideSkeleton()
                }
            }
            .store(in: &cancellables)

        viewModel
            .tripsDataPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] trips in
                self?.tableViewDataSource?.update(trips)
            }
            .store(in: &cancellables)

        viewModel.onErrorDidAppear = { [weak self] customError in
            self?.present(AlertFactory.createErrorAlert(message: customError.message), animated: true)
        }
    }

    func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTheme(_:)),
            name: NSNotification.Name(.AppStrings.Notification.updatedThemeKey),
            object: nil
        )
    }

    @objc private func updateTheme(_ notification: NSNotification) {
        myTripsView.updateTheme()
    }
}
