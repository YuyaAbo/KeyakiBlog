import UIKit
import RxCocoa
import RxSwift

class FollowViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let viewModel = FollowViewModel()
    private let dataSource = MemberDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.members.bindTo(collectionView.rx.items(dataSource: dataSource)).addDisposableTo(disposeBag)
    }

    @IBAction func toMain(_ sender: UIBarButtonItem) {
        let sb: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let view: MainViewController = sb.instantiateInitialViewController() as! MainViewController
        
        self.present(view, animated: true, completion: nil)
    }
}
