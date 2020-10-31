import Foundation

///Used to represent the objects in the Message Center. The MessageCenterDataSource is populated with an array of Message protocols. In the future, if other objects conform to the Message protocol (FullPageMessage, WebViewMessage), the dataSource will not need to be refactored.
///
/// Includes:
///- The ContentCardable protocol so all objects that conform to Message are inhereintly ContentCardable.
protocol Message: ContentCardable {
  var messageHeader: String? { get }
  var messageTitle: String? { get }
  var imageUrl: String? { get }
  var cardDescription: String? { get }
}

// MARK: - WebView Message
///The object that is responsible for working with the `message_webview` class_type from the Braze dashboard. When this message is clicked on in the Message Center, it will open to a WKWebView that loads either an html string or a url string.
struct WebViewMessage: Message {
  enum WebViewType {
    case html(String)
    case url(String)
    case contentBlock(String)
    case none
  }
  
  let contentCardData: ContentCardData?
  let webViewType: WebViewType
  let messageHeader: String?
  let messageTitle: String?
  let imageUrl: String?
  let cardDescription: String?
}

// MARK: - Computed Variables
extension WebViewMessage {
  var webViewString: String {
    switch webViewType {
    case .html(let htmlString):
      return htmlString
    case .url(let urlString):
      return urlString
    case .contentBlock(let contentBlockId):
      return contentBlockId
    default: return ""
    }
  }
}

// MARK: - Content Card Initializer
extension WebViewMessage {
  init?(metaData: [ContentCardKey: Any], classType contentCardClassType: ContentCardClassType) {
    guard let contentCardId = metaData[.idString] as? String,
      let createdAt = metaData[.created] as? Double,
      let isDismissable = metaData[.dismissable] as? Bool,
      let extras = metaData[.extras] as? [AnyHashable: Any]
      else { return nil }
    
    let imageUrl = metaData[.image] as? String
    let cardDescription = metaData[.cardDescription] as? String
    
    let messageHeader = extras[ContentCardKey.messageHeader.rawValue] as? String
    let messageTitle = extras[ContentCardKey.messageTitle.rawValue] as? String
    
    var webViewType: WebViewType = .none
    if let htmlString = extras[ContentCardKey.html.rawValue] as? String {
      webViewType = .html(htmlString)
    } else if let urlString = extras[ContentCardKey.url.rawValue] as? String {
      webViewType = .url(urlString)
    } else if let contentBlockId = extras[ContentCardKey.contentBlock.rawValue] as? String {
      webViewType = .contentBlock(contentBlockId)
    }
    
    let contentCardData = ContentCardData(contentCardId: contentCardId, contentCardClassType: contentCardClassType, createdAt: createdAt, isDismissable: isDismissable)
  
    
    self.init(contentCardData: contentCardData, webViewType: webViewType, messageHeader: messageHeader, messageTitle: messageTitle, imageUrl: imageUrl, cardDescription: cardDescription)
  }
}

// MARK: - Full Page Message
///The object that is responsible for working with the `message_full_page` class_type from the Braze dashboard. When this message is clicked on in the Message Center, it will open to a scrollable view of content in a classic view.
struct FullPageMessage: Message {
  let contentCardData: ContentCardData?
  let messageHeader: String?
  let messageTitle: String?
  let imageUrl: String?
  let cardTitle: String?
  let cardDescription: String?
}

// MARK: - Content Card Initializer
extension FullPageMessage {
  init?(metaData: [ContentCardKey: Any], classType contentCardClassType: ContentCardClassType) {
    guard let contentCardId = metaData[.idString] as? String,
      let createdAt = metaData[.created] as? Double,
      let isDismissable = metaData[.dismissable] as? Bool,
      let extras = metaData[.extras] as? [AnyHashable: Any]
      else { return nil }
    
    let imageUrl = metaData[.image] as? String
    let cardTitle = metaData[.title] as? String
    let cardDescription = metaData[.cardDescription] as? String
    
    let messageHeader = extras[ContentCardKey.messageHeader.rawValue] as? String
    let messageTitle = extras[ContentCardKey.messageTitle.rawValue] as? String ?? cardTitle
    
    let contentCardData = ContentCardData(contentCardId: contentCardId, contentCardClassType: contentCardClassType, createdAt: createdAt, isDismissable: isDismissable)
    
    self.init(contentCardData: contentCardData, messageHeader: messageHeader, messageTitle: messageTitle, imageUrl: imageUrl, cardTitle: cardTitle, cardDescription: cardDescription)
  }
}
