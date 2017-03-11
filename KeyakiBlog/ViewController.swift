import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    @IBOutlet weak var table: UITableView!
    
    private let viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.blogs.bindTo(table.rx.items(cellIdentifier: "Cell", cellType: ArticleCell.self)) { row, item, cell in
            cell.title?.text = item.title
            cell.author?.text = item.author
            cell.publishedAt?.text = item.publishedAt
        }
        .addDisposableTo(disposeBag)
    }

}

