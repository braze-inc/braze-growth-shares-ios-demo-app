import Foundation

protocol Purchasable {
  var price: Decimal { get }
}

// MARK: - TileList
struct TileList: Codable {
  var tiles: [Tile]
  
  private enum CodingKeys: String, CodingKey {
    case tiles
  }
}

// MARK: - Tile
struct Tile: ContentCardable, Purchasable, Codable, Hashable {
  private(set) var contentCardData: ContentCardData?
  let id: Int
  let title: String
  let price: Decimal
  let tags: [String]
  let imageUrl: String
    
  private enum CodingKeys: String, CodingKey {
    case id
    case title
    case price
    case tags
    case imageUrl = "image"
  }
}

// MARK: - Content Card Initalizer
extension Tile {
  init?(metaData: [ContentCardKey: Any], classType contentCardClassType: ContentCardClassType) {
    guard let idString = metaData[.idString] as? String,
      let createdAt = metaData[.created] as? Double,
      let isDismissable = metaData[.dismissable] as? Bool,
      let extras = metaData[.extras] as? [AnyHashable: Any],
      let title  = extras["tile_title"] as? String,
      let priceString = extras["tile_price"] as? String,
      let price = Decimal(string: priceString),
      let imageUrl = extras["tile_image"] as? String
      else { return nil }
    
    let tags = extras[ContentCardKey.tags.rawValue] as? String ?? ""
    let contentCardData = ContentCardData(contentCardId: idString, contentCardClassType: contentCardClassType, createdAt: createdAt, isDismissable: isDismissable)
    
    self.init(contentCardData: contentCardData, id: -1, title: title, price: price, tags: tags.separatedByCommaSpaceValue, imageUrl: imageUrl)
  }
}
