import RxSwift
import Kanna
import SDWebImage

struct ArticlesViewModel {
    
    private let disposeBag = DisposeBag()
    
    private var articles = Variable<[Article]>([])
    private var pageObject = Variable<Int>(0)
    private let fetchStatusObject = Variable<FetchStatus>(.default)
    enum FetchStatus {
        case `default`
        case fetching
    }
    
    var updatedArticles: Observable<[Article]> {
        return articles.asObservable()
    }
    var fetchStatus: Observable<FetchStatus> {
        return fetchStatusObject.asObservable()
    }
    
    func fetch() {
        
        if fetchStatusObject.value == .fetching { return }
        fetchStatusObject.value = .fetching

        APIClient.fetchArticles(page: pageObject.value)
            .subscribe(onNext: { value in
                let doc = HTML(html: value as! String, encoding: String.Encoding.utf8)
                var newArticles = [Article]()
                
                doc?.css("article").forEach( { (element) in
                    let title: String = (element.css("div.box-ttl").first?.css("a").first?.innerHTML!)!
                    let url: String = (element.css("div.box-ttl").first?.css("a[href]").first?["href"])!
                    let author: String = (element.css("p.name").first?.innerHTML!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
                    let publishedAt: String = (element.css("div.box-bottom").first?.css("li").first?.innerHTML!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
                    
                    // SDWebImageのsb_setImageを使いたいのでUIImageではなくUIImageViewを使ってるけどちょと微妙
                    let imageView = UIImageView()
                    if let imageHref: String = element.css("img[src]").first?["src"] {
                        imageView.sd_setImage(with: URL(string: imageHref), placeholderImage: #imageLiteral(resourceName: "Keyaki"))
                    } else {
                        imageView.image = #imageLiteral(resourceName: "Keyaki")
                    }
                    
                    let article = Article(0, title, url, author, publishedAt, imageView)
                    newArticles.append(article)
                })
                self.articles.value += newArticles
                self.pageObject.value += 1
            }, onError: { (error) in
                self.fetchStatusObject.value = FetchStatus.default
                // TODO: エラー文言表示する
                print(error)
            }, onCompleted: {
                self.fetchStatusObject.value = FetchStatus.default
                // TODO: 読み込み完了文言を表示してもいいかも
                print("Completed")
            }) {
                print("Disposed")
        }.disposed(by: disposeBag)
    }
    
    func refresh() {
        // fetch完了する前にVariableのvalueが空になるのでその時点でsubscribeされて
        // テーブルが空になるのでちょと微妙
        pageObject.value = 0
        articles.value = []
        fetch()
    }

}
