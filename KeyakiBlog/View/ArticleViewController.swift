import UIKit
import WebKit

class ArticleViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: UIWebView!
    var url: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        webView.loadRequest(urlRequest)
    }
}
