import UIKit
import WebKit

class ContentCardWebView: UIView {
  
  // MARK: - Outlets
  @IBOutlet private weak var webView: WKWebView!

  // MARK: - Variables
  private let htmlHead = "<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"></head>"
  private var htmlString: String?
  private var htmlFullString: String {
    guard let htmlString = htmlString else { return "" }
    
    return "\(htmlHead)\(htmlString)"
  }
  
  func configureURLForView(_ urlString: String?) {
    guard let urlString = urlString, let url = URL(string: urlString) else { return }
    webView.load(URLRequest(url: url))
  }
  
  func configureHTMLForView(_ htmlString: String?) {
    guard let htmlString = htmlString else { return }
    self.htmlString = htmlString
    webView.loadHTMLString(htmlFullString, baseURL: nil)
  }
}

