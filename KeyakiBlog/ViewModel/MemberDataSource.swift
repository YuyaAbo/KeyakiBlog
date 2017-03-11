import UIKit
import RxCocoa
import RxSwift

class MemberDataSource: NSObject, RxCollectionViewDataSourceType, UICollectionViewDataSource {
    
    typealias Element = [Member]
    
    var members: Element = []
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, observedEvent: Event<Array<Member>>) {
        if case .next(let members) = observedEvent {
            self.members = members
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return members.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberCell", for: indexPath) as! MemberCell
        let item = members[indexPath.row]
        cell.imageView.image = item.image
        return cell
    }

}
