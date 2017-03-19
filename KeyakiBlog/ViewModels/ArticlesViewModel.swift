import RxSwift
import Kanna

struct ArticlesViewModel {
    
    private var articles = Variable<[Article]>([])
    private var pageObject = Variable<Int>(0)
    
    var updatedArticles: Observable<[Article]> {
        return articles.asObservable()
    }
    
    func fetch() {
        let url = URL(string: "http://www.keyakizaka46.com/s/k46o/diary/member/list?ima=0000&page=\(pageObject.value)")
        var data = Data()
        do {
            data = try Data(contentsOf: url!)
        } catch {
            // TODO: エラー処理
        }
        
        let doc = HTML(html: data, encoding: String.Encoding.utf8)
        var newArticles = [Article]()
        
        doc?.css("article").forEach( { (element) in
            let title: String = (element.css("div.box-ttl").first?.css("a").first?.innerHTML!)!
            let url: String = (element.css("div.box-ttl").first?.css("a[href]").first?["href"])!
            let author: String = (element.css("p.name").first?.innerHTML!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
            let publishedAt: String = (element.css("div.box-bottom").first?.css("li").first?.innerHTML!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
            
            let article = Article(0, title, url, author, publishedAt)
            newArticles.append(article)
        })
        
        articles.value += newArticles
        pageObject.value += 1
    }
    
    func refresh() {
        pageObject.value = 0
        articles.value = []
        fetch()
    }

}
