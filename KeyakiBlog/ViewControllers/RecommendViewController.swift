import UIKit
import RxCocoa
import RxSwift

class RecommendViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private var viewModel = RecommendViewModel()

    @IBOutlet weak var toMainButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    private var recommendable: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "推しメン"
        
//        let memberTapped = collectionView.rx
//            .modelSelected(Member.self)
//            .flatMap({ (member) -> Observable<(RecommendAction, Int)> in
//                let action = member.isRecommended ? RecommendAction.unrecommend : RecommendAction.recommend
//                return Observable.just((action, member.id))
//            })
//            .shareReplayLatestWhileConnected()
        
        viewModel.members
            .bindTo(collectionView.rx.items(cellIdentifier: "MemberCell", cellType: MemberCell.self)) { row, element, cell in
                cell.imageView?.image = element.image
                cell.star?.isHidden = !element.isRecommended
            }
            .disposed(by: disposeBag)
        
//        viewModel.canRecommend
//            .subscribe(onNext: { recommendable in
//                self.recommendable = recommendable
//            }, onError: { error in
//                ()
//            })
//            .disposed(by: disposeBag)

        // メンバーを推しメンにできるか
//        Observable.combineLatest(memberTapped, viewModel.recommendedCount.distinctUntilChanged()) { (recommendEvent, recommendedCount) -> Observable<Any> in
//                switch recommendEvent.0 {
//                case .recommend:
//                    if recommendedCount < 10 {
//                        return Observable.just(recommendEvent.1)
//                    }
//                    return Observable.empty()
//                case .unrecommend:
//                    return Observable.just(recommendEvent.1)
//                }
//            }
//            .debug()
//            .flatMap({ (memberId) -> Observable<Void> in
//                return self.viewModel.recommend(id: memberId)
//            })
//            .disposed(by: disposeBag)
//        
        collectionView.rx
            .modelSelected(Member.self)
            .subscribe(onNext: { (member) in
                self.viewModel.updateRecommended(member: member.id)
            })
            .disposed(by: disposeBag)
        
        
        viewModel.fetch()
    }

}
