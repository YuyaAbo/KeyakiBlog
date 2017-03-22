import Alamofire
import RxSwift

class APIClient {

    static func fetchArticles(page: Int, memberId: Int? = nil) -> Observable<Any?> {
        
        var queryParameters: String = ""
        if memberId != nil {
            let articlePath = (MemberList(rawValue: memberId!)?.articlePath)!
            queryParameters = "&ct=\(articlePath)"
        }
        print(queryParameters)

        return Observable.create() { observer -> Disposable in
            let request = Alamofire.request("http://www.keyakizaka46.com/s/k46o/diary/member/list?ima=0000&page=\(page)" + queryParameters).responseString { response in
                switch response.result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }

}
