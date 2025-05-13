import UIKit
import SnapKit

final class MyTripsView: UIView {

    private lazy var title: UILabel = {
        LabelBuilder()
            .text(.AppStrings.AppTitles.myTravellingsTitle)
            .textColor(.label)
            .font(CustomFonts.bold(FontValues.big.value).font)
            .build()
    }()

    private(set) lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = .AppStrings.AppTitles.searchBar
        search.searchBarStyle = .minimal
        search.backgroundColor = .clear
        search.searchTextField.backgroundColor = .secondaryBG.withAlphaComponent(0.75)
        search.searchTextField.layer.cornerRadius = PaddingValues.default.value
        search.searchTextField.layer.masksToBounds = true
        search.searchTextField.font = CustomFonts.default(FontValues.default.value).font
        return search
    }()

    private(set) lazy var travellingsTableView: UITableView = {
        let table = UITableView()
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
        addSubview(searchBar)
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

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(PaddingValues.small.value)
            make.leading.trailing.equalToSuperview().inset(PaddingValues.small.value)
        }

        travellingsTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}
