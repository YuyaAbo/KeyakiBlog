import UIKit

class ArticleCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var publishedAt: UILabel!
    var url: String = ""

}
