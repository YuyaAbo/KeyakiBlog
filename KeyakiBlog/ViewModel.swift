import RxCocoa
import RxSwift
import Kanna

struct ViewModel {
    
    var articles: Observable<[Article]> {
        return Observable.of(fetch())
    }
    
    func fetch() -> [Article] {
        let url = URL(string: "http://www.keyakizaka46.com/s/k46o/diary/member/list?ima=0000")
        var data = Data()
        do {
            data = try Data(contentsOf: url!)
        } catch {
        }
        let doc = HTML(html: data, encoding: String.Encoding.utf8)
        
        var articles = [Article]()
        doc?.css("article").forEach( { (element) in
            let title: String = (element.css("div.box-ttl").first?.css("a").first?.innerHTML!)!
            let url: String = (element.css("div.box-ttl").first?.css("a[href]").first?["href"])!
            let author: String = (element.css("p.name").first?.innerHTML!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
            let publishedAt: String = (element.css("div.box-bottom").first?.css("li").first?.innerHTML!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!

            let article = Article(0, title, url, author, publishedAt)
            articles.append(article)
        })
        
        return articles
    }

}
