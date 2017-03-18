import RxCocoa
import RxSwift

struct FollowViewModel {
    
    private var members = Variable<[Member]>([])
    
    var updatedMembers: Observable<[Member]> {
        return members.asObservable()
    }
    
    func fetch() {
        var newMembers = [Member]()
        
        for member in MemberList.enumerate {
            let image: UIImage = member.image
            let isFollow: Bool = false
            newMembers.append(Member(member.rawValue, image, isFollow))
        }
        
        members.value = newMembers
    }
    
    func follow(id: Int) {
        let followed = members.value[id].isFollow
        members.value[id].isFollow = !followed
    }
    
}
