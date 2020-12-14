// MARK: - List
struct GroupList: MetaData {
  typealias Element = Group
  var items: [Group]
  
  private enum CodingKeys: String, CodingKey {
    case items = "groups"
  }
}

enum GroupStyle: String {
  case primary
  case secondary
  case largeRow
  case headline
  case none
  
  init?(rawValue: String) {
    switch rawValue {
    case "primary":
      self = .primary
    case "secondary":
      self = .secondary
    case "largerow":
      self = .largeRow
    case "headline":
      self = .headline
    default: return nil
    }
  }
}

// MARK: - Group
struct Group: ContentCardable, Codable, Hashable {
  private(set) var contentCardData: ContentCardData?
  let id: Int
  let title: String
  private let styleString: String
  
  private enum CodingKeys: String, CodingKey {
    case id
    case title
    case styleString = "style"
  }
}

extension Group {
  var style: GroupStyle {
    return GroupStyle(rawValue: styleString) ?? .none
  }
}

// MARK: - Content Card Initializer
extension Group {
  init?(metaData: [ContentCardKey : Any], classType contentCardClassType: ContentCardClassType) {
    guard let idString = metaData[.idString] as? String,
          let createdAt = metaData[.created] as? Double,
          let isDismissable = metaData[.dismissable] as? Bool,
          let message = metaData[.cardDescription] as? String,
          let extras = metaData[.extras] as? [AnyHashable: Any]
    else { return nil }
    
    let contentCardData = ContentCardData(contentCardId: idString, contentCardClassType: contentCardClassType, createdAt: createdAt, isDismissable: isDismissable)
    
    let styleString = extras[ContentCardKey.groupStyle.rawValue] as? String ?? ""
    
    let title = metaData[.title] as? String ?? ""
    let groupTitle = title.isEmpty ? title + message : title + " " + message
    
    self.init(contentCardData: contentCardData, id: -1, title: groupTitle, styleString: styleString)
  }
}
