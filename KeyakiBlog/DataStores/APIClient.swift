import Alamofire
import RxSwift

class APIClient {

    static func fetchArticles(page: Int) -> Observable<Any?> {

        return Observable.create() { observer -> Disposable in
            let request = Alamofire.request("http://www.keyakizaka46.com/s/k46o/diary/member/list?ima=0000&page=\(page)").responseString { response in
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
