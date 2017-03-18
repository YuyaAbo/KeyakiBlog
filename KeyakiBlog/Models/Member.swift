import UIKit

struct Member {

    var id: Int
    var image: UIImage
    var isFollow: Bool
    
    init(_ id: Int, _ image: UIImage, _ isFollow: Bool = false) {
        self.id = id
        self.image = image
        self.isFollow = isFollow
    }

}
