import UIKit
import WebKit

protocol MessageActionDelegate: AnyObject {
  func messageDeleted(_ message: Message)
}

class MessageCenterDetailViewController: UIViewController {
  
  // MARK: - Outlets
  @IBOutlet private weak var scrollView: UIScrollView!
  @IBOutlet private weak var contentView: UIView!
  @IBOutlet private weak var stackView: UIStackView!
  
  // MARK: - Actions
  @IBAction func trashCanButtonPressed(_ sender: Any) {
    delegate?.messageDeleted(message)
    
    navigationController?.popViewController(animated: true)
  }
  
  // MARK: - Variables
  private var message: Message!
  private weak var delegate: MessageActionDelegate?
}

// MARK: - View Lifecycle
extension MessageCenterDetailViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = message.messageHeader
    
    addContentCardToView(with: message)
  }
}

// MARK: - Public Methods
extension MessageCenterDetailViewController {
  func configure(with message: Message, delegate: MessageActionDelegate? = nil) {
    self.message = message
    self.delegate = delegate
  }
}

// MARK: - Private Methods
private extension MessageCenterDetailViewController {
  /// Querying the `class_type` to determine what detail view to load.
  ///
  /// The `class_type` is used to determine what the downcasted object must be to populate the corresponding view.
  /// - parameter message: The message that the user clicked on in the Message Center.
  func addContentCardToView(with message: Message) {
    switch message.contentCardData?.contentCardClassType {
    case .message(.fullPage):
      loadContentCardFullPageView(with: message as! FullPageMessage)
    case .message(.webView):
      loadContentCardWebView(with: message as! WebViewMessage)
    default:
      break
    }
  }
  
  func loadContentCardFullPageView(with message: FullPageMessage) {
    let contentCardView: ContentCardFullPageView = .fromNib()
    
    contentCardView.configureView(message.cardTitle, message.cardDescription, message.imageUrl)
    stackView.addArrangedSubview(contentCardView)
  }
  
  func loadContentCardWebView(with message: WebViewMessage) {
    let contentCardWebView: ContentCardWebView = .fromNib()
    
    switch message.webViewType {
    case .contentBlock(let contentBlockId):
      loadContentBlock(contentBlockId, for: contentCardWebView)
    case .url(let urlString):
      contentCardWebView.configureURLForView(urlString)
    case .html(let htmlString):
      contentCardWebView.configureHTMLForView(htmlString)
    default:
      break
    }
    
    layoutSubview(contentCardWebView)
  }
  
  func layoutSubview(_ subview: UIView) {
    view.addSubview(subview)
    subview.translatesAutoresizingMaskIntoConstraints = false
    let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .trailing, .leading]
    NSLayoutConstraint.activate(attributes.map {
      NSLayoutConstraint(item: subview, attribute: $0, relatedBy: .equal, toItem: view, attribute: $0, multiplier: 1, constant: 0)
    })
  }
  
  func loadContentBlock(_ contentBlockId: String?, for contentCardWebView: ContentCardWebView) {
    guard let contentBlockId = contentBlockId else { return }
    
    let contentBlockAPIKey = "YOUR-CONTENT-BLOCK-API-KEY"
    let parameters = ["content_block_id": contentBlockId]
    let request = ContentBlockRequest(contentBlockAPIKey: contentBlockAPIKey, parameters: parameters)
    
    APIURLRequest().make(request: request) { (result: APIResult<ContentBlock>) in
      switch result {
      case .success(let contentBlock):
        DispatchQueue.main.async {
          contentCardWebView.configureHTMLForView(contentBlock.content)
        }
      case .failure:
        break
      }
    }
  }
}

