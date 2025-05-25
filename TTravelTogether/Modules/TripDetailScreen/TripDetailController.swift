import UIKit
import Combine

final class TripDetailController: UIViewController {
    weak var coordinator: IMainCoordinator?

    private var tripDetailView: TripDetailView {
        view as! TripDetailView
    }
    private var viewModel: ITripDetailViewModel
    private var membersCollectionViewDataSource: MembersCollectionDataSource?
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: ITripDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        view = TripDetailView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

private extension TripDetailController {

    func setup() {
        setupDataSource()
        setupSkeletonable()
        setupBindings()
        setupNavigationItem()
    }

    func setupSkeletonable() {
        tripDetailView.makeSkeletonable()
        tripDetailView.tripMemebersCollectionView.showSkeleton()
    }

    func setupDataSource() {
        membersCollectionViewDataSource = MembersCollectionDataSource(viewModel: viewModel)
        tripDetailView.tripMemebersCollectionView.dataSource = membersCollectionViewDataSource
    }

    func setupBindings() {
        viewModel.tripDetailPublisher
            .dropFirst()
            .sink { [weak self] tripDetail in
                guard let self else { return }
                tripDetailView.setupWithTrip(tripDetail)
                tripDetailView.tripMemebersCollectionView.reloadData()
                tripDetailView.tripMemebersCollectionView.hideSkeleton()
                tripDetailView.tripMemebersCollectionView.isSkeletonable = false
                tripDetailView.activateTransactionButton()
                navigationItem.rightBarButtonItems?.forEach {
                    $0.setEnabled(true, enableColor: $0.tag == 1 ? .primaryRed : nil)
                }
            }
            .store(in: &cancellables)
    }

    func setupNavigationItem() {
        let leaveButton = UIBarButtonItem(
            title: "",
            image: SystemImages.leaveTrip.image.resized(to: UIElementsValues.tabBarItem.padding(PaddingValues.semiSmall.value).getSize),
            primaryAction: UIAction { [weak self] _ in
                guard let self else { return }
                let alert = AlertFactory.createLeaveTripAlert(
                    isAdmin: viewModel.isAdmin(),
                    onConfirm: {
                        // TODO: leave trip logic
                    }
                )
                navigationController?.present(alert, animated: true)
            },
            menu: nil
        )
        leaveButton.setEnabled(false)
        leaveButton.tag = 1

        let editButton = UIBarButtonItem(
            title: "",
            image: SystemImages.editTrip.image,
            primaryAction: UIAction { [weak self] _ in
                guard let self else { return }
                if !viewModel.isAdmin() {
                    navigationController?.present(AlertFactory.createEditTripAlert(), animated: true)
                } else {
                    coordinator?.showEditTripScreen(for: viewModel.tripDetail)
                }
            },
            menu: nil
        )
        editButton.setEnabled(false)
        editButton.tag = 0

        navigationItem.rightBarButtonItems = [leaveButton, editButton]
    }
}
