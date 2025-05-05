import UIKit
import SkeletonView

final class MembersCollectionDataSource: NSObject, UICollectionViewDataSource, SkeletonCollectionViewDataSource {

    var viewModel: ITripDetailViewModel

    init(viewModel: ITripDetailViewModel) {
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
