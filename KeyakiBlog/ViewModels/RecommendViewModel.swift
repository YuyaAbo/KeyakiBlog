import RxCocoa
import RxSwift

enum RecommendAction {
    case recommend
    case unrecommend
}

class RecommendViewModel {
    
    private let disposeBag = DisposeBag()
    private let membersObject = Variable<[Member]>([])
    
    var members: Observable<[Member]> {
        return membersObject.asObservable()
    }
    var canRecommend: Single<Bool> {
        return Single<Bool>
            .create(subscribe: { (observer) -> Disposable in
                var count = 0
                self.membersObject.value.forEach({ (member) in
                    if member.isRecommended { count += 1 }
                })
                observer(.success(count < 10))
                return Disposables.create()
            })
    }
    
    func fetch() {
        var newMembers = [Member]()
        
        let recommendedIds = RecommendSubject.recommendedIdsObject.value
        for member in MemberList.enumerate {
            if recommendedIds.contains(member.rawValue) {
                RecommendSubject.recommendedIdsObject.value.append(member.rawValue)
                newMembers.append(Member(member.rawValue, member.image, true))
            } else {
                newMembers.append(Member(member.rawValue, member.image, false))
            }
        }
        
        membersObject.value = newMembers
    }
    
    func updateRecommended(member id: Int) {
        let isRecommended = self.membersObject.value[id].isRecommended

        canRecommend
            .subscribe { (result) in
                switch result {
                case .success(let recommendable):
                    if isRecommended {
                        self.unrecommend(member: id)
                        break
                    }
                    if recommendable {
                        self.recommend(member: id)
                        break
                    }
                case .error(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func resetRecommended() {
        RecommendSubject.recommendedIdsObject.value = [MemberList.ishimori.rawValue]
        UserDefaultsClient.instantinate().recommendedIds = [MemberList.ishimori.rawValue]
        fetch()
    }
    
    private func recommend(member id: Int) {
        RecommendSubject.recommendedIdsObject.value.append(id)
        var ids = UserDefaultsClient.instantinate().recommendedIds
        ids.append(id)
        UserDefaultsClient.instantinate().recommendedIds = ids
        self.membersObject.value[id].isRecommended = true
    }

    private func unrecommend(member id:Int) {
        RecommendSubject.recommendedIdsObject.value = RecommendSubject.recommendedIdsObject.value.filter { $0 != id }
        let ids = UserDefaultsClient.instantinate().recommendedIds
        UserDefaultsClient.instantinate().recommendedIds = ids.filter { $0 != id }
        self.membersObject.value[id].isRecommended = false
    }
    
}
