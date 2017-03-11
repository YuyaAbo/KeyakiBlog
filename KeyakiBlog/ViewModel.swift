import RxCocoa
import RxSwift

struct ViewModel {
    
    var blogs: Observable<[Blog]> {
        return Observable.of(Blog.dummies)
    }

}
