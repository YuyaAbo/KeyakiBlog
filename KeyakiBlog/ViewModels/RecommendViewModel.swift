import RxCocoa
import RxSwift

struct RecommendViewModel {
    
    private let disposeBag = DisposeBag()
    private var membersObject = Variable<[Member]>([])
    
    var members: Observable<[Member]> {
        return membersObject.asObservable()
    }
    var canRecommend: Observable<Bool> {
        return membersObject.asObservable()
            .map {
                var recommendedNum = 0
                $0.forEach{
                    if $0.isRecommended { recommendedNum += 1 }
                }
                return recommendedNum < 10
            }
            .shareReplayLatestWhileConnected()
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
        print("推し")
        let isRecommended = membersObject.value[id].isRecommended
        UserDefaultsClient.instantinate(memberID: id).memberIsRecommended = !isRecommended
        if !isRecommended {
            RecommendSubject.recommendedIdsObject.value.append(id)
        } else {
            RecommendSubject.recommendedIdsObject.value = RecommendSubject.recommendedIdsObject.value.filter { $0 != id }
        }
        membersObject.value[id].isRecommended = !isRecommended
    }
    
}
