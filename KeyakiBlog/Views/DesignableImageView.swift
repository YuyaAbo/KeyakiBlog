import UIKit

@IBDesignable

class DesignableImageView: UIImageView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }

}
