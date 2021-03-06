import UIKit
import RxCocoa
import RxSwift

class RecommendViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private var viewModel = RecommendViewModel()

    @IBOutlet weak var resetButton: DesignableButton!
    @IBOutlet weak var collectionView: UICollectionView!
    private var recommendable: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "推しメン"
        
        viewModel.members
            .bindTo(collectionView.rx.items(cellIdentifier: "MemberCell", cellType: MemberCell.self)) { row, element, cell in
                cell.imageView?.image = element.image
                cell.star?.isHidden = !element.isRecommended
            }
            .disposed(by: disposeBag)
        
        let reset = resetButton.rx.tap
        reset.subscribe(onNext: { [weak self] (_) in
            self?.viewModel.resetRecommended()
            self?.collectionView.reloadData()
        })
        .disposed(by: disposeBag)
        

        collectionView.rx
            .modelSelected(Member.self)
            .subscribe(onNext: { (member) in
                self.viewModel.updateRecommended(member: member.id)
            })
            .disposed(by: disposeBag)
        
        
        viewModel.fetch()
    }

}
