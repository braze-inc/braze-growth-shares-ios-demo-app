import SwiftUI

final class HomeViewModel: NSObject, ObservableObject {
  @Published var data: HomeData?
  
  private lazy var result: APIResult<HomeData> = {
    return LocalDataCoordinator().loadData(fileName: "Home-List", withExtension: "json")
  }()
  
  func requestContentCards() {
    BrazeManager.shared.addObserverForContentCards(observer: self, selector: #selector(contentCardsUpdated))
    BrazeManager.shared.requestContentCardsRefresh()
  }
  
  @objc func contentCardsUpdated(_ notification: Notification) {
    let pills = BrazeManager.shared.handleContentCardsUpdated(notification, for: [.home(.pill)]) as? [Pill]
    let bottles = BrazeManager.shared.handleContentCardsUpdated(notification, for: [.home(.bottle)]) as? [Bottle]
    
    switch result {
    case .success(let data):
      self.data = data
    case .failure(let error):
      print(error)
    }
    
    self.data?.pills += pills ?? []
    self.data?.bottles += bottles ?? []
  }
  
  var pills: [Pill] {
    return data?.pills ?? []
  }
  
  var bottles: [Bottle] {
    return data?.bottles ?? []
  }
  
  var composites: [Composite] {
    return data?.composites ?? []
  }
}

protocol HomeItem: ContentCardable, Codable {
  var title: String { get }
  var imageUrlString: String { get }
}

extension HomeItem {
  var imageUrl: URL? {
    return URL(string: imageUrlString)
  }
}

struct HomeData: Codable {
#warning("TODO change to let, refactor request")
  var pills: [Pill]
  var bottles: [Bottle]
  let composites: [Composite]
}

struct Pill: HomeItem, Hashable {
  private(set) var contentCardData: ContentCardData?
  private(set) var title: String
  private(set) var imageUrlString: String
  
  let eventName: String?
  
  private enum CodingKeys: String, CodingKey {
    case title
    case imageUrlString = "image"
    case eventName = "event_name"
  }
}

extension Pill {
  init?(metaData: [ContentCardKey : Any], classType contentCardClassType: ContentCardClassType) {
    guard let idString = metaData[.idString] as? String,
          let createdAt = metaData[.created] as? Double,
          let isDismissible = metaData[.dismissible] as? Bool,
          let title = metaData[.title] as? String,
          let imageUrlString = metaData[.image] as? String,
          let extras = metaData[.extras] as? [AnyHashable: Any]
    else { return nil }
    
    let eventName = extras["event_name"] as? String
    
    let contentCardData = ContentCardData(contentCardId: idString, contentCardClassType: contentCardClassType, createdAt: createdAt, isDismissible: isDismissible)
    
    self.init(contentCardData: contentCardData, title: title, imageUrlString: imageUrlString, eventName: eventName)
  }
}

struct Composite: Codable, Hashable {
  let id: Int
  let title: String
  let subtitle: String
  let miniBottles: [MiniBottle]
}

struct Bottle: HomeItem, Hashable {
  private(set) var contentCardData: ContentCardData?
  private(set) var title: String
  private(set) var imageUrlString: String
  
  private enum CodingKeys: String, CodingKey {
    case title
    case imageUrlString = "image"
  }
}

extension Bottle {
  init?(metaData: [ContentCardKey : Any], classType contentCardClassType: ContentCardClassType) {
    guard let idString = metaData[.idString] as? String,
          let createdAt = metaData[.created] as? Double,
          let isDismissible = metaData[.dismissible] as? Bool,
          let title = metaData[.title] as? String,
          let imageUrlString = metaData[.image] as? String
    else { return nil }
    
    let contentCardData = ContentCardData(contentCardId: idString, contentCardClassType: contentCardClassType, createdAt: createdAt, isDismissible: isDismissible)
    
    self.init(contentCardData: contentCardData, title: title, imageUrlString: imageUrlString)
  }
}

struct MiniBottle: HomeItem, Hashable {
  let compositeId: Int
  private(set) var contentCardData: ContentCardData?
  private(set) var title: String
  private(set) var imageUrlString: String
  
  private enum CodingKeys: String, CodingKey {
    case compositeId = "composite_id"
    case title
    case imageUrlString = "image"
  }
}

extension MiniBottle {
  init?(metaData: [ContentCardKey : Any], classType contentCardClassType: ContentCardClassType) {
    guard let idString = metaData[.idString] as? String,
          let createdAt = metaData[.created] as? Double,
          let isDismissible = metaData[.dismissible] as? Bool,
          let title = metaData[.title] as? String,
          let imageUrlString = metaData[.image] as? String,
          let extras = metaData[.extras] as? [AnyHashable: Any],
          let compositeIdString = extras["composite_id"] as? String,
          let compositeId = Int(compositeIdString)
    else { return nil }
    
    let contentCardData = ContentCardData(contentCardId: idString, contentCardClassType: contentCardClassType, createdAt: createdAt, isDismissible: isDismissible)
    
    self.init(compositeId: compositeId, contentCardData: contentCardData, title: title, imageUrlString: imageUrlString)
  }
}

