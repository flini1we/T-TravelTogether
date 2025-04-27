import UIKit
import Combine

final class TripDetailController: UIViewController {

    private var tripDetailView: TripDetailView {
        view as! TripDetailView
    }
    private var viewModel: TripDetailVMProtocol
    private var membersCollectionViewDataSource: MembersCollectionDataSource?
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: TripDetailVMProtocol) {
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
        tripDetailView.tripMemebersCollectionView.showAnimatedGradientSkeleton()
    }
}

private extension TripDetailController {

    func setup() {
        setupSkeletonable()
        setupDataSource()
        setupBindings()
        setupNavigationItem()
    }

    func setupSkeletonable() {
        tripDetailView.tripTitle.showAnimatedGradientSkeleton()
    }

    func setupDataSource() {
        membersCollectionViewDataSource = MembersCollectionDataSource(viewModel: viewModel)
        tripDetailView.tripMemebersCollectionView.dataSource = membersCollectionViewDataSource
    }

    func setupBindings() {
        viewModel.tripDetailPublisher
            .dropFirst()
            .sink { [weak self] tripDetail in
                self?.tripDetailView.setupWithTrip(tripDetail)
                self?.tripDetailView.tripMemebersCollectionView.reloadData()
                self?.tripDetailView.tripMemebersCollectionView.hideSkeleton()
                self?.tripDetailView.activateTransactionButton()
            }
            .store(in: &cancellables)
    }

    func setupNavigationItem() {
        let leaveButton = UIBarButtonItem(
            title: "",
            image: SystemImages.leaveTrip.image.resized(to: UIElementsValues.tabBarItem.padding(10).getSize),
            primaryAction: UIAction { _ in },
            menu: nil
        )
        leaveButton.tintColor = .primaryRed

        let editButton = UIBarButtonItem(
            title: "",
            image: SystemImages.editTrip.image,
            primaryAction: UIAction { _ in },
            menu: nil
        )

        navigationItem.rightBarButtonItems = [leaveButton, editButton]
    }
}
