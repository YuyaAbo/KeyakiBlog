import UIKit
import RxCocoa
import RxSwift

class FollowViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = FollowViewModel()

    @IBOutlet weak var toMainButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.updatedMembers
            .bindTo(collectionView.rx.items(cellIdentifier: "MemberCell", cellType: MemberCell.self)) { row, element, cell in
                cell.imageView?.image = element.image
                cell.star?.isHidden = !element.isFollow
            }
            .disposed(by: disposeBag)
        
        collectionView.rx
            .modelSelected(Member.self)
            .subscribe { [weak self] (value) in
                self?.viewModel.follow(id: (value.element?.id)!)
            }.disposed(by: disposeBag)
        
        // go back main
        let tapped = toMainButton.rx.tap
        tapped.subscribe { [weak self] _ in
            let sb: UIStoryboard = UIStoryboard(name: "Articles", bundle: Bundle.main)
            let view: ArticlesViewController = sb.instantiateInitialViewController() as! ArticlesViewController
            
            self?.show(view, sender: self)
            }
            .disposed(by: disposeBag)
        
        viewModel.fetch()
    }
}
