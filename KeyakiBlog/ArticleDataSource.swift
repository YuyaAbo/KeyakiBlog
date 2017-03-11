import UIKit
import RxCocoa
import RxSwift

class ArticleDataSource: NSObject, RxTableViewDataSourceType, UITableViewDataSource, SectionedViewDataSourceType {
    
    typealias Element = [Article]
    
    var articles: Element = []
    private let selectedIndexPath = PublishSubject<IndexPath>()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, observedEvent: Event<Array<Article>>) {
        if case .next(let articles) = observedEvent {
            self.articles = articles
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ArticleCell
        let item = articles[indexPath.row]
        cell.title?.text = item.title
        cell.author?.text = item.author
        cell.url = item.url
        cell.publishedAt?.text = item.publishedAt
        return cell
    }
    
    func model(at indexPath: IndexPath) throws -> Any {
        return articles[indexPath.row]
    }

}
