import UIKit
import SkeletonView

final class MembersCollectionDataSource: NSObject, UICollectionViewDataSource, SkeletonCollectionViewDataSource {

    var viewModel: TripDetailVMProtocol

    init(viewModel: TripDetailVMProtocol) {
        self.viewModel = viewModel
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.tripDetail.getMembersSequence().count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MemberCollectionViewCell.identifier,
            for: indexPath) as! MemberCollectionViewCell
        cell.setupWithUser(
            viewModel.tripDetail.getMembersSequence()[indexPath.row], at: indexPath
        )
        return cell
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        MemberCollectionViewCell.identifier
    }
}

/*final class MembersCollectionDataSource: NSObject {

    var viewModel: TripDetailVMProtocol
    var dataSource: UICollectionViewDiffableDataSource<Sections, User>?

    init(viewModel: TripDetailVMProtocol) {
        self.viewModel = viewModel
        super.init()
    }

    func setupDataSource(with collectionView: UICollectionView) {
        dataSource = UICollectionViewDiffableDataSource<Sections, User>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, user in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MemberCollectionViewCell.identifier,
                    for: indexPath) as! MemberCollectionViewCell
                cell.setupWithUser(user, at: indexPath)
                return cell
            }
        )
        applyFreshSnapshot(data: viewModel.tripDetail.getMembersSequence())
    }

    func applyFreshSnapshot(data: [User]) {
        var snapshot = NSDiffableDataSourceSnapshot<Sections, User>()

        snapshot.appendSections([.main])
        snapshot.appendItems(data)

        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}*/
