import UIKit
import RxCocoa
import RxSwift

class FollowViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    @IBOutlet weak var toMainButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let viewModel = FollowViewModel()
    private let dataSource = MemberDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.members
            .bindTo(collectionView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
       
        viewModel.members
            .asObservable()
            .bindNext { [weak self] _ in
            self?.collectionView.reloadData()
            }
            .addDisposableTo(disposeBag)
        /*collectionView.rx.modelSelected(Member.self).subscribe { (event) in
            self.viewModel.members.bindTo(self.collectionView.rx.items(dataSource: self.dataSource)).addDisposableTo(self.disposeBag)
        }.disposed(by: disposeBag)*/
        
        // go back main
        let tapped = toMainButton.rx.tap
        tapped.subscribe { [weak self] _ in
            let sb: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let view: MainViewController = sb.instantiateInitialViewController() as! MainViewController
            
            self?.present(view, animated: true, completion: nil)
            }
            .addDisposableTo(disposeBag)
    }
}
