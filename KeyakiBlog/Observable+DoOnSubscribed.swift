import RxSwift

/**
 * こうしてWrapperでくるまないとビルドエラーになる
 * 参考：https://gist.github.com/mono0926/78bf126d9bd887276793410890c44e38
 * 参考：https://github.com/ReactiveX/RxSwift/issues/925
 */
struct DisposableWrapper: Disposable {
    
    private let disposable: Disposable
    
    init(disposable: Disposable) {
        self.disposable = disposable
    }
    
    func dispose() {
        disposable.dispose()
    }
}

extension Observable {
    public func `do`(onSubscribed: @escaping () -> (), onDisposed: @escaping () -> ()) -> Observable {
        return Observable.using({
            return self.wrapMethod(onSubscribed: onSubscribed, onDisposed: onDisposed)
        }, observableFactory: { _ -> Observable in
            return self
        })
    }
    
    private func wrapMethod(onSubscribed: @escaping () -> (), onDisposed: @escaping () -> ()) -> DisposableWrapper {
        onSubscribed()
        return DisposableWrapper(disposable: Disposables.create(with: onDisposed))
    }
}
