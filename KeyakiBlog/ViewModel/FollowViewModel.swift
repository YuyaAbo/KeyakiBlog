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
            members.append(Member(image))
        }
        
        return members
    }
    
}
