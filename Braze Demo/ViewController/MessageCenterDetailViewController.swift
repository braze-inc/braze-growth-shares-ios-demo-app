import UIKit
import WebKit

protocol MessageActionDelegate: class {
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
    let customHTMLCardView: ContentCardWebView = .fromNib()
    
    customHTMLCardView.configureView(message.webViewString)
    view.addSubview(customHTMLCardView)
    
    customHTMLCardView.translatesAutoresizingMaskIntoConstraints = false
    let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .trailing, .leading]
    NSLayoutConstraint.activate(attributes.map {
      NSLayoutConstraint(item: customHTMLCardView, attribute: $0, relatedBy: .equal, toItem: view, attribute: $0, multiplier: 1, constant: 0)
    })
  }
}

