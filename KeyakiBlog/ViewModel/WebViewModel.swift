import RxSwift

struct WebViewModel {
    
    private var backButtonEnabledSubject = Variable<Bool>(false)
    private var forwardButtonEnabledSubject = Variable<Bool>(false)
    
    var backButtonEnabled: Observable<Bool> {
        return backButtonEnabledSubject.asObservable()
    }
    var forwardButtonEnabled: Observable<Bool> {
        return forwardButtonEnabledSubject.asObservable()
    }
    
    func updateButtons(canGoBack: Bool, canGoForward: Bool) {
        backButtonEnabledSubject.value = canGoBack
        forwardButtonEnabledSubject.value = canGoForward
    }
}
