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
        
        for member in MemberList.enumerate {
            let isRecommended: Bool = UserDefaultsClient.instantinate(memberID: member.rawValue).memberIsRecommended
            if isRecommended {
                RecommendSubject.recommendedIdsObject.value.append(member.rawValue)
            }
            newMembers.append(Member(member.rawValue, member.image, isRecommended))
        }
        
        membersObject.value = newMembers
    }
    
//    func recommend(id: Int) {
//        let isRecommended = membersObject.value[id].isRecommended
//        UserDefaultsClient.instantinate(memberID: id).memberIsRecommended = !isRecommended
//        if !isRecommended {
//            RecommendSubject.recommendedIdsObject.value.append(id)
//        } else {
//            RecommendSubject.recommendedIdsObject.value = RecommendSubject.recommendedIdsObject.value.filter { $0 != id }
//        }
//        membersObject.value[id].isRecommended = !isRecommended
//    }
    
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
    
    private func recommend(member id: Int) {
        UserDefaultsClient.instantinate(memberID: id).memberIsRecommended = true
        RecommendSubject.recommendedIdsObject.value.append(id)
        self.membersObject.value[id].isRecommended = true
    }

    private func unrecommend(member id:Int) {
        UserDefaultsClient.instantinate(memberID: id).memberIsRecommended = false
        RecommendSubject.recommendedIdsObject.value = RecommendSubject.recommendedIdsObject.value.filter { $0 != id }
        self.membersObject.value[id].isRecommended = false
    }
    
}
