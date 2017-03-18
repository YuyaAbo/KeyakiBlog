import RxCocoa
import RxSwift

class ArticlesViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = ArticlesViewModel()

    @IBOutlet weak var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "欅ブログ"
        
        viewModel.updatedArticles
            .bindTo(table.rx.items(cellIdentifier: "ArticleCell", cellType: ArticleCell.self)) { row, element, cell in
                cell.title?.text = element.title
                cell.author?.text = element.author
                cell.url = element.url
                cell.publishedAt?.text = element.publishedAt
            }
            .disposed(by: disposeBag)
        
        table.rx
            .modelSelected(Article.self)
            .subscribe { [weak self] value in
                let url = URL(string: "http://www.keyakizaka46.com/" + value.element!.url)!
                self?.show(WebViewController.instantiate(url), sender: self)
            }
            .disposed(by: disposeBag)
        
        table.rx
            .didScroll
            .subscribe { [weak self] value in
                if (self?.table.contentOffset.y)! >= ((self?.table.contentSize.height)! - (self?.table.bounds.size.height)!),
                    (self?.table.isDragging)! {
                    self?.viewModel.fetch()
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.fetch()
    }

}

