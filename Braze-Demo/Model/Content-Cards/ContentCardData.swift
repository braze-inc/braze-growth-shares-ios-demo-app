import Foundation

///Extends custom object functionality to contain Content Card object data without any depencies of the Appboy-iOS-SDK. The logging methods can be called directly from conforming objects. For example, to log a click for a message in the Message Center, `message.logContentCardImpression()` all is that is needed.
///
/// Includes:
///- A `ContentCardData` object that represents the `ABKContentCard` data along with a `ContentCardClassType` enum.
/// - An initializer used to instantiate custom objects with `ABKContentCard` meta data.
protocol ContentCardable {
  var contentCardData: ContentCardData? { get }
  init?(metaData: [ContentCardKey: Any], classType contentCardClassType: ContentCardClassType)
}

extension ContentCardable {
  var isContentCard: Bool {
    return contentCardData != nil
  }
  
  func logContentCardClicked() {
    BrazeManager.shared.logContentCardClicked(idString: contentCardData?.contentCardId)
  }
  
  func logContentCardDismissed() {
    BrazeManager.shared.logContentCardDismissed(idString: contentCardData?.contentCardId)
  }
  
  func logContentCardImpression() {
    BrazeManager.shared.logContentCardImpression(idString: contentCardData?.contentCardId)
  }
}

// MARK: - ContentCardData
struct ContentCardData: Hashable {
  let contentCardId: String
  let contentCardClassType: ContentCardClassType
  let createdAt: Double
  let isDismissible: Bool
}

// MARK: - Equatable
extension ContentCardData: Equatable {
  static func ==(lhs: ContentCardData, rhs: ContentCardData) -> Bool {
    return lhs.contentCardId == rhs.contentCardId
  }
}

// MARK: - ContentCardKey
/// A safer alternative to typing "string" types. Declared as `String` type to query the key name via `rawValue`.
///
///Represents the keys in your Content Card key-value pairs.
enum ContentCardKey: String {
  // MARK: - Custom
  case idString
  case created
  case classType = "class_type"
  case dismissible
  case extras
  case image
  case title
  case cardDescription
  case messageHeader = "message_header"
  case messageTitle = "message_title"
  case html
  case discountPercentage = "discount_percentage"
  case tags = "tile_tags"
  case contentBlock = "content_block_id"
  case detail = "tile_detail"
  case groupStyle = "group_style"
  case urlString
  
  // MARK: - Out of the Box
  case backgroundColor = "background_color"
  case borderColor = "border_color"
  case borderWidth = "border_width"
  case cornerRadius = "corner_radius"
  case fontStyle = "font_style"
  case labelColor = "label_color"
  case linkColor = "link_color"
  case unreadColor = "unread_color"
}

// MARK: - ContentCardClassType
///Represents the `class_type` in your Content Card key-value pairs.
enum ContentCardClassType: Hashable {
  case ad
  case coupon
  case item(ItemType)
  case message(MessageCenterViewType)
  case none
  
  enum ItemType {
    case tile
    case group
  }
  
  enum MessageCenterViewType {
    case fullPage
    case webView
  }
  
  /// - parameter rawType: This value must be synced with the `class_type` value that has been set up in your Braze dashboard or its type will be set to `ContentCardClassType.none.`
  init(rawType: String?) {
    switch rawType?.lowercased() {
    case "coupon_code":
      self = .coupon
    case "home_tile":
      self = .item(.tile)
    case "group":
      self = .item(.group)
    case "message_full_page":
      self = .message(.fullPage)
    case "message_webview":
      self = .message(.webView)
    case "ad_banner":
      self = .ad
    default:
      self = .none
    }
  }
}
