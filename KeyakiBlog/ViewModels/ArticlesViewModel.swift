import RxSwift
import Kanna
import SDWebImage

struct ArticlesViewModel {
    
    private let disposeBag = DisposeBag()
    
    private var articlesObject = Variable<[Article]>([])
    private var memberPageObject = Variable<[Int: Int]>([:]) // メンバーごとのページ
    private let fetchStatusObject = Variable<FetchStatus>(.default)
    private let fetchEachMemberStatusObject = Variable<[Int: FetchStatus]>([:])

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
    
    // 同じメンバーの同じページの並列実行は許さないようにする
    func fetch(member id: Int) {
        if fetchEachMemberStatusObject.value[id] == .fetching { return }

        // メンバーごとにページングの管理したいから
        var page = 0
        self.page(member: id)
            .subscribe(onNext: { nextPage in
                if nextPage == 0 { self.memberPageObject.value[id] = 0 }
                page = nextPage
            })
            .disposed(by: disposeBag)

        APIClient.fetchArticles(page: page, memberId: id)
            .do(onSubscribed: { 
                self.fetchEachMemberStatusObject.value[id] = .fetching
                self.fetchStatusObject.value = .fetching
            }, onDisposed: { 
                self.fetchEachMemberStatusObject.value[id] = .default
                self.fetchStatusObject.value = .default
            })
            .subscribe(onNext: { value in
                let newArticles = self.generateArticles(html: value as! String)
                self.articlesObject.value += newArticles
                self.memberPageObject.value.updateValue(page, forKey: id)
            }, onCompleted: {
                // だいたいメンバーごとに配列に入ってるのでpublishedAt順にするため
                self.articlesObject.value.sort(by: { (a, b) -> Bool in
                    a.publishedAt >= b.publishedAt
                })
            })
            .disposed(by: disposeBag)
    }
    
    func refresh() {
        // fetch完了する前にVariableのvalueが空になるのでその時点でsubscribeされて
        // テーブルが空になるのでちょと微妙か？
        memberPageObject.value = [:]
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
    
    private func page(member id: Int) -> Observable<Int> {
        if memberPageObject.value.contains(where: { return $0.key == id }) {
            let page = memberPageObject.value[id]!
            return Observable.just(page + 1)
        }
        return Observable.just(0)
    }
    
}
