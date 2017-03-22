import UIKit
import RxCocoa
import RxSwift

class RecommendViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = RecommendViewModel()

    @IBOutlet weak var toMainButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "推しメン"
        
        viewModel.members
            .bindTo(collectionView.rx.items(cellIdentifier: "MemberCell", cellType: MemberCell.self)) { row, element, cell in
                cell.imageView?.image = element.image
                cell.star?.isHidden = !element.isRecommended
            }
            .disposed(by: disposeBag)
        
        collectionView.rx
            .modelSelected(Member.self)
            .subscribe { [weak self] (value) in
                self?.viewModel.recommend(id: (value.element?.id)!)
            }.disposed(by: disposeBag)
        
        viewModel.fetch()
    }

}
