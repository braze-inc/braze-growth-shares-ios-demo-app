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
    // Not Braze Dashboard configured (yet)
    self.init(contentCardData: nil, id: 0, styleString: "", items: [])
  }
}

// MARK: - Item
struct Subgroup: Codable, Hashable {
  let id: Int
  let title: String
  let image: String?
}
