import Foundation

// MARK: - HomeItem
struct HomeItem: Codable, Hashable, HomeColorable {
  private(set) var contentCardData: ContentCardData?
  let id: Int
  let title: String
  let eventName: String?
  let image: ImageMetaData?
  private(set) var imageUrlString: String?
  private(set) var fontColorString, backgroundColorString: String?
  let compositeID: Int?

  enum CodingKeys: String, CodingKey {
    case id, title, image
    case eventName = "event_name"
    case backgroundColorString = "background_color"
    case fontColorString = "font_color"
    case compositeID = "composite_id"
  }
}

extension HomeItem {
  var imageUrl: URL? {
    if let urlString = image?.data?.attributes.url {
      let domain = "https://masquerade.k8s.tools-001.p-use-1.braze.com"
      return URL(string: domain + urlString)
    } else if let urlString = imageUrlString {
      return URL(string: urlString)
    } else {
      return nil
    }
  }
}

extension HomeItem: ContentCardable {
  init?(metaData: [ContentCardKey : Any], classType contentCardClassType: ContentCardClassType) {
    guard let idString = metaData[.idString] as? String,
          let createdAt = metaData[.created] as? Double,
          let isDismissible = metaData[.dismissible] as? Bool,
          let title = metaData[.title] as? String,
          let imageUrlString = metaData[.image] as? String,
          let extras = metaData[.extras] as? [AnyHashable: Any]
    else { return nil }
    
    let contentCardData = ContentCardData(contentCardId: idString, contentCardClassType: contentCardClassType, createdAt: createdAt, isDismissible: isDismissible)
   
    var compositeID: Int?
    if let compositeIDString = extras[ContentCardKey.compositeId.rawValue] as? String {
      compositeID = Int(compositeIDString)
    }
    
    self.init(contentCardData: contentCardData, id: 0, title: title, eventName: "", image: nil, imageUrlString: imageUrlString, fontColorString: "#FFFFFF", backgroundColorString: "#000000", compositeID: compositeID)
  }
}

