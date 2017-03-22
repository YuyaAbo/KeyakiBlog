import UIKit

struct Member {

    var id: Int
    var image: UIImage
    var isRecommended: Bool
    
    init(_ id: Int, _ image: UIImage, _ isRecommended: Bool = false) {
        self.id = id
        self.image = image
        self.isRecommended = isRecommended
    }

}
