import UIKit
import RxCocoa
import RxSwift

class MainViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    @IBOutlet weak var table: UITableView!
    
    private let viewModel = MainViewModel()
    private let dataSource = ArticleDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.articles.bindTo(table.rx.items(dataSource: dataSource)).addDisposableTo(disposeBag)

        table.rx.modelSelected(Article.self).subscribe { (value) in
            let sb: UIStoryboard = UIStoryboard(name: "Article", bundle: Bundle.main)
            let view: ArticleViewController = sb.instantiateInitialViewController() as! ArticleViewController
            
            view.url = "http://www.keyakizaka46.com/" + value.element!.url
            self.present(view, animated: true, completion: nil)
            //print(value.element!.url)
        }
        .disposed(by: disposeBag)
    }

    
    @IBAction func toFollow(_ sender: UIBarButtonItem) {
        let sb: UIStoryboard = UIStoryboard(name: "Follow", bundle: Bundle.main)
        let view: FollowViewController = sb.instantiateInitialViewController() as! FollowViewController
        
        self.present(view, animated: true, completion: nil)
    }
}

