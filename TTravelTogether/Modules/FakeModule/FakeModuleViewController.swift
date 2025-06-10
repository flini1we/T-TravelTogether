import UIKit
import SnapKit

final class FakeModuleViewController: UIViewController {

    private(set) lazy var titleImageView: UIImageView = {
        let imageView = UIImageView(image: .launchSceen)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .primaryYellow
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension FakeModuleViewController {

    func setup() {
        view.backgroundColor = .primaryYellow
        setupView()
    }

    func setupView() {
        setupSubviews()
        setupConstraints()
    }

    func setupSubviews() {
        view.addSubview(titleImageView)
    }

    func setupConstraints() {
        titleImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
