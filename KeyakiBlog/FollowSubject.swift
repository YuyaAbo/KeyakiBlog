import RxSwift

class RecommendSubject {
    
    static let recommendedIdsObject = Variable<[Int]>(UserDefaultsClient.instantinate().recommendedIds)

}
