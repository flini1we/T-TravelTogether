import UIKit
import SnapKit

final class CreateTripView: UIView, ICreateTripView {
    var onShowingContacts: (() -> Void)?

    private(set) lazy var tripTitleField: UITextField = {
        TextFieldBuilder()
            .font(.systemFont(ofSize: FontValues.default.value))
            .cornerRadius(.default)
            .placeHolder(.AppStrings.CreateTrip.createTripTitle)
            .returnKeyType(.continue)
            .keyboardType(.default)
            .paddinLeft(PaddingValues.default.value)
            .delegate(self)
            .build()
    }()

    private(set) lazy var tripPriceField: UITextField = {
        TextFieldBuilder()
            .font(.systemFont(ofSize: FontValues.default.value))
            .cornerRadius(.default)
            .placeHolder(.AppStrings.CreateTrip.createTripPrice)
            .returnKeyType(.done)
            .keyboardType(.numberPad)
            .paddinLeft(PaddingValues.default.value)
            .delegate(self)
            .build()
    }()

    private lazy var textFieldsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            tripTitleField,
            tripPriceField
        ])
        stack.axis = .vertical
        stack.spacing = PaddingValues.default.value
        return stack
    }()

    private lazy var tripDateLabel: UILabel = {
        LabelBuilder()
            .font(CustomFonts.bold(FontValues.medium.value).font)
            .text(.AppStrings.CreateTrip.tripDateTitle)
            .textColor(.label)
            .build()
    }()

    private lazy var startsAtTitle: UILabel = {
        LabelBuilder()
            .font(CustomFonts.default(FontValues.default.value).font)
            .textColor(.label)
            .text(.AppStrings.CreateTrip.tripStartsAtTitle)
            .build()
    }()

    private lazy var startsAtCalendar: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.minimumDate = .now
        datePicker.addAction(UIAction { [weak self] _ in
            self?.updateDate()
        }, for: .valueChanged)
        return datePicker
    }()

    private lazy var startsAtData: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            startsAtTitle,
            startsAtCalendar
        ])
        stack.spacing = PaddingValues.default.value
        return stack
    }()

    private lazy var endsAtTitle: UILabel = {
        LabelBuilder()
            .font(CustomFonts.default(FontValues.default.value).font)
            .textColor(.label)
            .text(.AppStrings.CreateTrip.tripEndsAtTitle)
            .build()
    }()

    private lazy var endsAtCalendar: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.minimumDate = startsAtCalendar.date
        return datePicker
    }()

    private lazy var endsAtData: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            endsAtTitle,
            endsAtCalendar
        ])
        stack.spacing = PaddingValues.default.value
        return stack
    }()

    private lazy var dateStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            tripDateLabel,
            startsAtData,
            endsAtData
        ])
        stack.axis = .vertical
        stack.spacing = PaddingValues.tiny.value
        return stack
    }()

    private lazy var membersLabel: UILabel = {
        LabelBuilder()
            .font(CustomFonts.bold(FontValues.medium.value).font)
            .text(.AppStrings.CreateTrip.tripMembers)
            .textColor(.label)
            .build()
    }()

    private lazy var addMemberButton: UIButton = {
        let button = ButtonBuilder()
            .tintColor(.primaryBlue)
            .title(.AppStrings.CreateTrip.addMemberTitle)
            .disableContentEdgesInsets()
            .build()
        button.addAction(UIAction { [weak self] _ in
            self?.onShowingContacts?()
        }, for: .touchUpInside)
        return button
    }()

    private(set) lazy var tripMemebersCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.itemSize = UIElementsValues.memberCollectionViewCell.size
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout
        )
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            MemberCollectionViewCell.self,
            forCellWithReuseIdentifier: MemberCollectionViewCell.identifier
        )
        collectionView.makeSkeletonable()
        return collectionView
    }()

    private lazy var membersStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            membersLabel,
            addMemberButton
        ])
        stack.spacing = PaddingValues.default.value
        stack.distribution = .equalSpacing
        return stack
    }()

    private(set) lazy var createButton: UIButton = {
        ButtonBuilder()
            .tintColor(.buttonLabel)
            .font(CustomFonts.bold(FontValues.default.value).font)
            .backgroundColor(.primaryYellow)
            .title(.AppStrings.CreateTrip.create)
            .cornerRadius(.default)
            .build()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getTripDates() -> (start: Date, finish: Date) {
        (startsAtCalendar.date, endsAtCalendar.date)
    }

    func setupWithEditedTrip(tripDetail: TripDetail) {
        tripTitleField.text = tripDetail.title
        tripPriceField.text = "\(tripDetail.price)"
        startsAtCalendar.date = tripDetail.startsAt
        endsAtCalendar.date = tripDetail.finishAt
    }

    func addCreateTripAction(_ action: UIAction) {
        createButton.addAction(action, for: .touchUpInside)
    }

    func updateTheme(_ theme: AppTheme) {
        backgroundColor = theme == .light ? .systemBackground : .black
    }
}

extension CreateTripView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case tripTitleField:
            tripPriceField.becomeFirstResponder()
        case tripPriceField:
            self.endEditing(true)
        default:
            break
        }
        return true
    }
}

private extension CreateTripView {

    func setup() {
        backgroundColor = .systemBackground
        setupDismiss()
        setupSubviews()
        setupConstraints()
    }

    func setupSubviews() {
        addSubview(textFieldsStackView)
        addSubview(dateStackView)
        addSubview(membersStackView)
        addSubview(createButton)
        addSubview(tripMemebersCollectionView)
    }

    func setupConstraints() {
        textFieldsStackView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(PaddingValues.medium.value)
        }

        dateStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(PaddingValues.medium.value)
            make.top.equalTo(textFieldsStackView.snp.bottom).offset(PaddingValues.medium.value)
        }

        membersStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(PaddingValues.medium.value)
            make.top.equalTo(dateStackView.snp.bottom).offset(PaddingValues.medium.value)
        }

        tripMemebersCollectionView.snp.makeConstraints { make in
            make.height.equalTo(UIElementsValues.memberCollectionViewCell.size.height)
            make.leading.trailing.equalToSuperview().inset(PaddingValues.medium.value)
            make.top.equalTo(membersStackView.snp.bottom).offset(PaddingValues.default.value)
        }

        createButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-PaddingValues.default.value)
            make.leading.trailing.equalToSuperview().inset(PaddingValues.medium.value)
        }
    }

    func updateDate() {
        endsAtCalendar.minimumDate = startsAtCalendar.date

        if endsAtCalendar.date < startsAtCalendar.date {
            endsAtCalendar.setDate(startsAtCalendar.date, animated: true)
        }
    }
}
