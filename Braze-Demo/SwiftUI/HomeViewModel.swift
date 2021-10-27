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
    let pills = BrazeManager.shared.handleContentCardsUpdated(notification, for: [.home(.pill)]) as? [HomeItem]
    
    switch result {
    case .success(let data):
      self.data = data
    case .failure(let error):
      print(error)
    }
    
    self.data?.pills += pills ?? []
  }
  
  var pills: [HomeItem] {
    return data?.pills ?? []
  }
  
  var bottles: [HomeItem] {
    return data?.bottles ?? []
  }
  
  var composites: [Composite] {
    return data?.composites ?? []
  }
}

protocol Displayable {
  var title: String { get }
  var imageUrlString: String { get }
}

extension Displayable {
  var imageUrl: URL? {
    return URL(string: imageUrlString)
  }
}

struct HomeData: Codable {
  var pills: [HomeItem]
  let bottles: [HomeItem]
  let composites: [Composite]
}

struct HomeItem: ContentCardable, Displayable, Codable, Hashable {
  private(set) var contentCardData: ContentCardData?
  private(set) var title: String
  private(set) var imageUrlString: String
  
  private enum CodingKeys: String, CodingKey {
    case title
    case imageUrlString = "image"
  }
}

// MARK: - Content Card Initializer
extension HomeItem {
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

struct Composite: Codable, Hashable {
  let title: String
  let subtitle: String
  let miniBottles: [HomeItem]
}
