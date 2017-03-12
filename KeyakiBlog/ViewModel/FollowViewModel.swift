import RxCocoa
import RxSwift
import Kanna

struct FollowViewModel {
    
    var members: Observable<[Member]> {
        return Observable.of(fetch())
    }
    
    func fetch() -> [Member] {
        var members = [Member]()
        
        for member in MemberList.enumerate {
            let image: UIImage = member.image
            let isFollow: Bool = false
            members.append(Member(image, isFollow))
        }
        
        return members
    }
    
}
