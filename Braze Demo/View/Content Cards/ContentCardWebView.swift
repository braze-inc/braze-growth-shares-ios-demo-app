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
  
  func configureView(_ webViewString: String?) {
    guard let webViewString = webViewString else { return }
    
    if let url = URL(string: webViewString) {
      webView.load(URLRequest(url: url))
    } else if webViewString.contains("<html") && webViewString.contains("/html>") {
      self.htmlString = webViewString
      webView.loadHTMLString(htmlFullString, baseURL: nil)
    }
  }
}

