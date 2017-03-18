import UIKit
import RxCocoa
import RxSwift

class ArticleCell: UITableViewCell {
    
    var disposeBag = DisposeBag()

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var publishedAt: UILabel!
    var url: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // 再利用時にdisposeBagに溜まっていたものを破棄
        self.disposeBag = DisposeBag()
    }

}
