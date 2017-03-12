import UIKit

struct Member {

    var image: UIImage
    var isFollow: Bool
    
    init(_ image: UIImage, _ isFollow: Bool = false) {
        self.image = image
        self.isFollow = isFollow
    }
    
    mutating func setIsFollow(bool: Bool) {
        self.isFollow = bool
    }

}
