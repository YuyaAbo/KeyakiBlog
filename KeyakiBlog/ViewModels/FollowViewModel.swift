import RxCocoa
import RxSwift

struct FollowViewModel {
    
    private var membersObject = Variable<[Member]>([])
    
    var members: Observable<[Member]> {
        return membersObject.asObservable()
    }
    
    func fetch() {
        var newMembers = [Member]()
        
        for member in MemberList.enumerate {
            let image: UIImage = member.image
            let isFollow: Bool = UserDefaultsClient.instantinate(memberID: member.rawValue).memberIsFollowed
            if isFollow {
                FollowSubject.followedIdsObject.value.append(member.rawValue)
            }
            newMembers.append(Member(member.rawValue, image, isFollow))
        }
        
        membersObject.value = newMembers
    }
    
    func follow(id: Int) {
        let followed = membersObject.value[id].isFollow
        UserDefaultsClient.instantinate(memberID: id).memberIsFollowed = !followed
        if followed {
            FollowSubject.followedIdsObject.value = FollowSubject.followedIdsObject.value.filter { $0 != id }
        } else {
            FollowSubject.followedIdsObject.value.append(id)
        }
        membersObject.value[id].isFollow = !followed
    }
    
}
