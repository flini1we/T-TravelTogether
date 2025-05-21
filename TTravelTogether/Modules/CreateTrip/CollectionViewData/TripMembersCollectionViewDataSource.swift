import UIKit

final class TripMembersCollectionViewDataSource: NSObject, UICollectionViewDataSource {

    var createTripViewModel: ICreateTripViewModel

    init(viewModel: ICreateTripViewModel) {
        self.createTripViewModel = viewModel
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        createTripViewModel.tripMembers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MemberCollectionViewCell.identifier,
            for: indexPath) as? MemberCollectionViewCell else { return UICollectionViewCell() }
        cell.setupWithUser(
            createTripViewModel.tripMembers[indexPath.row],
            at: indexPath
        )
        return cell
    }
}
