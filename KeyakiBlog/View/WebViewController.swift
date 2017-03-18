import UIKit
import WebKit
import RxSwift

class WebViewController: UIViewController, WKNavigationDelegate {
    
    private let disposedBag = DisposeBag()
    private let viewModel = WebViewModel()
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!

    private let webView = WKWebView()
    private(set) var url: URL!
    
    private init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func instantiate(_ url: URL) -> WebViewController {
        let sb: UIStoryboard = UIStoryboard(name: "Web", bundle: Bundle.main)
        let view: WebViewController = sb.instantiateInitialViewController() as! WebViewController
        
        view.url = url
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.backButtonEnabled.bindTo(backButton.rx.isEnabled).disposed(by: disposedBag)
        viewModel.forwardButtonEnabled.bindTo(forwardButton.rx.isEnabled).disposed(by: disposedBag)
        
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 44.0).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        
        webView.load(URLRequest(url: url))
    }

    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @IBAction func forwardButtonTapped(_ sender: UIBarButtonItem) {
        webView.goForward()
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        viewModel.updateButtons(canGoBack: webView.canGoBack, canGoForward: webView.canGoForward)
    }
    
}
