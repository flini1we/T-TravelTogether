import UIKit

final class ICloudNavTitle: UIView {

    private lazy var image: UIImageView = {
        UIImageView(image: SystemImages.handRaised.image)
    }()

    private lazy var title: UILabel = {
        LabelBuilder()
            .font(CustomFonts.bold(FontValues.default.value).font)
            .textColor(.label)
            .text(.AppStrings.Contacts.iCloudTitle)
            .build()
    }()

    private lazy var dataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            image,
            title
        ])
        stack.spacing = PaddingValues.tiny.value
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ICloudNavTitle {

    func setup() {
        setupSubviews()
        setupConstraints()
    }

    func setupSubviews() {
        addSubview(dataStackView)
    }

    func setupConstraints() {
        dataStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        image.snp.makeConstraints { make in
            make.height.width.equalTo(PaddingValues.semiBig.value)
        }
    }
}
