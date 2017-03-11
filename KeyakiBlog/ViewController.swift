import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    @IBOutlet weak var table: UITableView!
    
    private let viewModel = ViewModel()
    private let dataSource = ArticleDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.articles.bindTo(table.rx.items(dataSource: dataSource)).addDisposableTo(disposeBag)

        table.rx.modelSelected(Article.self).subscribe { (value) in
            print(value.element!.url)
        }
        .disposed(by: disposeBag)
    }

}

