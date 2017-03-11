import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    @IBOutlet weak var table: UITableView!
    
    private let viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.blogs.bindTo(table.rx.items(cellIdentifier: "Cell")) { row, item, cell in
            cell.textLabel?.text = item.title
        }
        .addDisposableTo(disposeBag)
    }

}

