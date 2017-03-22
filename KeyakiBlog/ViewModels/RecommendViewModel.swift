import RxCocoa
import RxSwift

struct RecommendViewModel {
    
    private var membersObject = Variable<[Member]>([])
    
    var members: Observable<[Member]> {
        return membersObject.asObservable()
    }
    
    func fetch() {
        var newMembers = [Member]()
        
        for member in MemberList.enumerate {
            let image: UIImage = member.image
            let isRecommended: Bool = UserDefaultsClient.instantinate(memberID: member.rawValue).memberIsRecommended
            if isRecommended {
                RecommendSubject.recommendedIdsObject.value.append(member.rawValue)
            }
            newMembers.append(Member(member.rawValue, image, isRecommended))
        }
        
        membersObject.value = newMembers
    }
    
    func recommend(id: Int) {
        let isRecommended = membersObject.value[id].isRecommended
        UserDefaultsClient.instantinate(memberID: id).memberIsRecommended = !isRecommended
        if isRecommended {
            RecommendSubject.recommendedIdsObject.value = RecommendSubject.recommendedIdsObject.value.filter { $0 != id }
        } else {
            RecommendSubject.recommendedIdsObject.value.append(id)
        }
        membersObject.value[id].isRecommended = !isRecommended
    }
    
}
