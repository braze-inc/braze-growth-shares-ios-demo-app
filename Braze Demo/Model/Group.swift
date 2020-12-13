// MARK: - List
struct GroupList: MetaData {
  typealias Element = Group
  var items: [Group]
  
  private enum CodingKeys: String, CodingKey {
    case items = "groups"
  }
}

enum GroupStyle: String {
  case smallRow
  case largeRow
  case headline
  case none
  
  init?(rawValue: String) {
    switch rawValue {
    case "smallrow":
      self = .smallRow
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
  private let styleString: String
  let items: [Subgroup]
  
  private enum CodingKeys: String, CodingKey {
    case id
    case styleString = "style"
    case items
  }
}

extension Group {
  var style: GroupStyle {
    return GroupStyle(rawValue: styleString) ?? .none
  }
}

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
    let item = Subgroup(id: 1, title: groupTitle, image: nil)
    
    self.init(contentCardData: contentCardData, id: 0, styleString: styleString, items: [item])
  }
}

// MARK: - Item
struct Subgroup: Codable, Hashable {
  let id: Int
  let title: String
  let image: String?
}
