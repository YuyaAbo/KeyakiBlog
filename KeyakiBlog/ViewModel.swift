import RxCocoa
import RxSwift
import Kanna

struct ViewModel {
    
    var blogs: Observable<[Blog]> {
        return Observable.of(fetch())
    }
    
    func fetch() -> [Blog] {
        let url = URL(string: "http://www.keyakizaka46.com/s/k46o/diary/member/list?ima=0000")
        var data = Data()
        do {
            data = try Data(contentsOf: url!)
        } catch {
        }
        let doc = HTML(html: data, encoding: String.Encoding.utf8)
        
        var articles = [Blog]()
        doc?.css("article").forEach( { (element) in
            let title: String = (element.css("div.box-ttl").first?.css("a").first?.innerHTML!)!
            let author: String = (element.css("p.name").first?.innerHTML!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
            var publishedAt: String = ""
            element.css("div.box-date").first?.css("time").forEach( { (time) in
                publishedAt = publishedAt + time.innerHTML!
            })
            let article = Blog(0, title, author, publishedAt)
            articles.append(article)
        })
        
        return articles
    }

}
