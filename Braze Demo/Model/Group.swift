// MARK: - List
struct GroupList: MetaData {
  typealias Element = Group
  var items: [Group]
  
  private enum CodingKeys: String, CodingKey {
    case items = "groups"
  }
}

// MARK: - Group
struct Group: ContentCardable, Codable, Hashable {
  private(set) var contentCardData: ContentCardData?
  let id: Int
  let name: String
  let items: [Subgroup]
  
  private enum CodingKeys: String, CodingKey {
    case id
    case name
    case items
  }
}

extension Group {
  init?(metaData: [ContentCardKey : Any], classType contentCardClassType: ContentCardClassType) {
    self.init(contentCardData: nil, id: 0, name: "", items: [])
  }
}

// MARK: - Item
struct Subgroup: Codable, Hashable {
  let id: Int
  let title: String
  let image: String?
}
