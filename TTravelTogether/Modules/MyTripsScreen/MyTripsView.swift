import UIKit
import SnapKit

final class MyTripsView: UIView {
    var onTableViewRefresh: (() -> Void)?

    private lazy var title: UILabel =
        .showTitleLabel(.AppStrings.AppTitles.myTravellingsTitle, size: .big)

    private(set) lazy var travellingsTableView: UITableView = {
        let table = UITableView()
        let refreshControl = UIRefreshControl()
        refreshControl.addAction(UIAction { [weak self] _ in
            self?.onTableViewRefresh?()
            refreshControl.endRefreshing()
        }, for: .valueChanged)
        table.addSubview(refreshControl)
        table.refreshControl = refreshControl
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.register(TripTableViewCell.self, forCellReuseIdentifier: TripTableViewCell.identifier)
        table.contentInset = UIEdgeInsets(top: PaddingValues.small.value, left: 0, bottom: 0, right: 0)
        table.rowHeight = UIElementsValues.tripCellHeight.value
        table.makeSkeletonable()
        return table
    }()

    private lazy var bgImageView: UIImageView = {
        let imageView = UIImageView(image: .myTripsBGLogo)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTheme() {
        travellingsTableView.visibleCells.forEach {
            guard let cell = $0 as? TripTableViewCell else { return }
            cell.bgView.layer.shadowColor = ThemeManager.current == .light ? UIColor.label.cgColor : UIColor.white.cgColor
        }
    }
}

private extension MyTripsView {

    func setup() {
        backgroundColor = .systemBackground
        makeSkeletonable()
        setupSubviews()
        setupConstraints()
    }

    func setupSubviews() {
        addSubview(bgImageView)
        addSubview(title)
        addSubview(travellingsTableView)
    }

    func setupConstraints() {
        bgImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(snp.bottom)
            make.height.equalTo(UIScreen.main.bounds.height * 0.3)
        }

        title.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().inset(PaddingValues.medium.value)
        }

        travellingsTableView.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(PaddingValues.small.value)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}
