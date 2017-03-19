import RxSwift
import Kanna

struct ArticlesViewModel {
    
    private let disposeBag = DisposeBag()
    
    private var articles = Variable<[Article]>([])
    private var pageObject = Variable<Int>(0)
    
    var updatedArticles: Observable<[Article]> {
        return articles.asObservable()
    }
    
    func fetch() {

        APIClient.fetchArticles(page: pageObject.value)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { value in
                let doc = HTML(html: value as! String, encoding: String.Encoding.utf8)
                var newArticles = [Article]()
                
                doc?.css("article").forEach( { (element) in
                    let title: String = (element.css("div.box-ttl").first?.css("a").first?.innerHTML!)!
                    let url: String = (element.css("div.box-ttl").first?.css("a[href]").first?["href"])!
                    let author: String = (element.css("p.name").first?.innerHTML!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
                    let publishedAt: String = (element.css("div.box-bottom").first?.css("li").first?.innerHTML!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
                    
                    var image: UIImage
                    if let imageHref: String = element.css("img[src]").first?["src"] {
                        let imageUrl = URL(string: imageHref)
                        var data = Data()
                        do {
                            data = try Data(contentsOf: imageUrl!)
                            image = UIImage(data: data)!
                        } catch {
                            // TODO: エラー処理
                            image = #imageLiteral(resourceName: "Keyaki")
                        }
                    } else {
                        image = #imageLiteral(resourceName: "Keyaki")
                    }
                    
                    let article = Article(0, title, url, author, publishedAt, image)
                    newArticles.append(article)
                })
                self.articles.value += newArticles
                self.pageObject.value += 1
            }, onError: { (error) in
                print(error)
            }, onCompleted: { 
                print("Completed")
            }) { 
                print("Disposed")
        }.disposed(by: disposeBag)
        
        /*let url = URL(string: "http://www.keyakizaka46.com/s/k46o/diary/member/list?ima=0000&page=\(pageObject.value)")
        var data = Data()
        do {
            data = try Data(contentsOf: url!)
        } catch {
            // TODO: エラー処理
        }*/
    }
    
    func refresh() {
        pageObject.value = 0
        articles.value = []
        fetch()
    }

}
