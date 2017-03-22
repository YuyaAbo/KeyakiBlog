import RxCocoa
import RxSwift

class ArticlesViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = ArticlesViewModel()

    @IBOutlet weak var table: UITableView!
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "欅ブログ"
        
        table.estimatedRowHeight = 63
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        table.addSubview(refreshControl)
        
        viewModel.fetchStatus
            .map {
                // 2個あるから微妙
                switch $0 {
                case .default:
                    self.activityIndicator.stopAnimating()
                    self.refreshControl.endRefreshing()
                case .fetching:
                    self.activityIndicator.startAnimating()
                    self.refreshControl.beginRefreshing()
                }
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(UIControlEvents.valueChanged)
            .subscribe { [weak self] value in
                self?.viewModel.refresh()
                self?.viewModel.fetch()
                self?.table.reloadData()
            }
            .disposed(by: disposeBag)
        
        viewModel.articles
            .bindTo(table.rx.items(cellIdentifier: "ArticleCell", cellType: ArticleCell.self)) { row, element, cell in
                cell.title?.text = element.title
                cell.author?.text = element.author
                cell.url = element.url
                cell.publishedAt?.text = element.publishedAt
                cell.titleImage.image = element.imageView.image
            }
            .disposed(by: disposeBag)
        
        table.rx
            .modelSelected(Article.self)
            .subscribe { [weak self] value in
                let url = URL(string: "http://www.keyakizaka46.com/" + value.element!.url)!
                self?.show(WebViewController.instantiate(url), sender: self)
            }
            .disposed(by: disposeBag)
        
        // 追加読み込み、判定微妙
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
    
    override func viewWillAppear(_ animated: Bool) {
        // ひとりでも推しメンがいた場合は
        if RecommendSubject.recommendedIdsObject.value.count >= 1 {
            self.viewModel.refresh()
            RecommendSubject.recommendedIdsObject.value.forEach({ [weak self] (id) in
                print(id)
                self?.viewModel.fetch(member: id)
            })
            self.table.reloadData()
        }
    }

}

