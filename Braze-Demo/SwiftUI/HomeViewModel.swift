import SwiftUI
import Combine

@MainActor
final class HomeViewModel: NSObject, ObservableObject {
  @Published var meta: HomeMetaData = HomeMetaData.empty
  
  func requestHomeData() async {
    self.meta = await ContentOperationQueue(classTypes: [.home(.pill), .home(.bottle), .home(.miniBottle)]).downloadContent()
  }
  
  var header: Header {
    return  meta.data.attributes.header
  }
  
  var pills: [HomeItem] {
    return meta.data.attributes.pills
  }
  
  var bottles: [HomeItem] {
    return  meta.data.attributes.bottles
  }
  
  var composites: [Composite] {
    return  meta.data.attributes.composites
  }
}

extension HomeItem {
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

// MARK: - HomeMetaData
struct HomeMetaData: Codable {
  var data: HomeData
}

extension HomeMetaData {
  static var empty: HomeMetaData {
    return HomeMetaData(data: HomeData(id: -1, attributes: HomeAttributes(createdAt: "", updatedAt: "", publishedAt: "", configuration: HomeConfiguration(id: -1, apiKey: "", configTitle: "", attributesDescription: "", vertical: ""), header: Header(id: -1, title: "", fontColorString: nil, backgroundColorString: nil), pills: [], bottles: [], composites: [])))
  }
}

// MARK: - HomeData
struct HomeData: Codable {
  let id: Int
  var attributes: HomeAttributes
}

// MARK: - HomeAttributes
struct HomeAttributes: Codable {
  let createdAt, updatedAt, publishedAt: String
  let configuration: HomeConfiguration
  let header: Header
  var pills, bottles: [HomeItem]
  var composites: [Composite]
  
  enum CodingKeys: String, CodingKey {
    case createdAt, updatedAt, publishedAt, header, pills, bottles, composites
    case configuration = "attributes"
  }
}

// MARK: - HomeConfiguration
struct HomeConfiguration: Codable {
  let id: Int
  let apiKey: String?
  let configTitle, attributesDescription, vertical: String

  enum CodingKeys: String, CodingKey {
    case id, vertical
    case apiKey = "api_key"
    case configTitle = "config_title"
    case attributesDescription = "description"
  }
}

// MARK: - HomeItem
struct HomeItem: ContentCardable, Codable, Hashable, HomeColorable {
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

// MARK: - Image
struct ImageMetaData: Codable, Hashable {
  let data: ImageData?
}

// MARK: - ImageData
struct ImageData: Codable, Hashable  {
  let id: Int
  let attributes: ImageAttributes
}

// MARK: - ImageAttributes
struct ImageAttributes: Codable, Hashable {
  let url: String
  let previewURL: String?

  enum CodingKeys: String, CodingKey {
    case url
    case previewURL = "previewUrl"
  }
}

protocol HomeColorable {
  var fontColorString: String? { get }
  var backgroundColorString: String? { get}
}

extension HomeColorable {
  var fontColor: Color {
    return Color(fontColorString?.colorValue() ?? .black)
  }
  
  var backgroundColor: Color {
    return Color(backgroundColorString?.colorValue() ?? .white)
  }
}

// MARK: - Composite
struct Composite: Codable, Hashable, HomeColorable {
  let id: Int
  let title, subtitle: String
  private(set) var fontColorString, backgroundColorString: String?
  let compositeID: Int
  var miniBottles: [HomeItem]

  enum CodingKeys: String, CodingKey {
    case id, title, subtitle
    case fontColorString = "font_color"
    case backgroundColorString = "background_color"
    case compositeID = "composite_id"
    case miniBottles = "mini_bottles"
  }
}

// MARK: - Header
struct Header: Codable, HomeColorable {
  let id: Int
  let title: String
  private(set) var fontColorString, backgroundColorString: String?

  enum CodingKeys: String, CodingKey {
    case id, title
    case fontColorString = "font_color"
  }
}
