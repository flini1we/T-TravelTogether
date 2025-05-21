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

    func updateTrips() {
        myTripsView.travellingsTableView.isSkeletonable = true
        viewModel.loadData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MyTripsController {

    func setup() {
        myTripsView.travellingsTableView.isSkeletonable = true
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
        viewModel.onTripsUpdate = { [weak self] trips in
            self?.tableViewDataSource?.update(trips)
        }

        viewModel
            .isLoadingDataPublisher
            .sink { [weak self] isLoading in
                guard let self else { return }
                _ = isLoading ? myTripsView.travellingsTableView.showSkeleton()
                              : myTripsView.travellingsTableView.hideSkeleton()
            }
            .store(in: &cancellables)
    }
}
