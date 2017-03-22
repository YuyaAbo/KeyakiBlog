import RxSwift
import Kanna
import SDWebImage

struct ArticlesViewModel {
    
    private let disposeBag = DisposeBag()
    
    private var articlesObject = Variable<[Article]>([])
    private var pageObject = Variable<Int>(0)
    private let fetchStatusObject = Variable<FetchStatus>(.default)

    enum FetchStatus {
        case `default`
        case fetching
    }
    
    var articles: Observable<[Article]> {
        return articlesObject.asObservable()
    }
    var fetchStatus: Observable<FetchStatus> {
        return fetchStatusObject.asObservable()
    }
    
    func fetch() {
        if fetchStatusObject.value == .fetching { return }

        fetchStatusObject.value = .fetching

        APIClient.fetchArticles(page: pageObject.value)
            .subscribe(onNext: { value in
                let newArticles = self.generateArticles(html: value as! String)
                self.articlesObject.value += newArticles
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
    
    // 並列で実行してもいい？
    func fetch(member id: Int) {
        APIClient.fetchArticles(page: 0, memberId: id)
            .subscribe(onNext: { value in
                let newArticles = self.generateArticles(html: value as! String)
                self.articlesObject.value += newArticles
                self.pageObject.value += 1
            }, onError: { (error) in
                // TODO: エラー文言表示する
                print(error)
            }, onCompleted: {
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
        articlesObject.value = []
    }
    
    // Webページをスクレイピングして[Article]を生成
    private func generateArticles(html: String) -> [Article] {
        let doc = HTML(html: html, encoding: String.Encoding.utf8)
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
        
        return newArticles
    }
    
}
