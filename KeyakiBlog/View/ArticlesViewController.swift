import RxCocoa
import RxSwift

class ArticlesViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = ArticlesViewModel()

    @IBOutlet weak var toFollowButton: UIBarButtonItem!
    @IBOutlet weak var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let tapped = toFollowButton.rx.tap
        tapped.subscribe { [weak self] _ in
            let sb: UIStoryboard = UIStoryboard(name: "Follow", bundle: Bundle.main)
            let view: FollowViewController = sb.instantiateInitialViewController() as! FollowViewController
            
            self?.show(view, sender: self)
            }
            .disposed(by: disposeBag)
        
        viewModel.fetch()
    }

}

