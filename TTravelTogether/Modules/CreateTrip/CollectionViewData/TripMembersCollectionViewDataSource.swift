import UIKit

final class TripMembersCollectionViewDataSource: NSObject, UICollectionViewDataSource {

    var users: [User]
    var collectionView: UICollectionView

    init(data users: [User], collectionView: UICollectionView) {
        self.users = users
        self.collectionView = collectionView
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        users.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MemberCollectionViewCell.identifier,
            for: indexPath) as? MemberCollectionViewCell else { return UICollectionViewCell() }
        cell.setupWithUser(
            users[indexPath.row],
            at: indexPath
        )
        return cell
    }

    func updateUsers(data: [User]) {
        self.users = data
        withAnimation {
            self.collectionView.reloadData()
        }
    }
}

private extension TripMembersCollectionViewDataSource {

    func withAnimation(_ completion: @escaping (() -> Void)) {
        UIView.transition(
            with: collectionView,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {
                completion()
            },
            completion: nil)
    }
}
