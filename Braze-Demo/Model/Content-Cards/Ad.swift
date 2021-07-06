import Foundation

// MARK: - Ad
///The object that represents the inline ad banner on the home screen. Can be instantiated from Content Card payload data.
struct Ad: Hashable, ContentCardable {
  let contentCardData: ContentCardData?
  let imageUrl: String?
}

extension Ad {
  init?(metaData: [ContentCardKey: Any], classType contentCardClassType: ContentCardClassType) {
    guard let contentCardId = metaData[.idString] as? String,
      let createdAt = metaData[.created] as? Double,
      let isDismissible = metaData[.dismissible] as? Bool
      else { return nil }
    
    let contentCardData = ContentCardData(contentCardId: contentCardId, contentCardClassType: contentCardClassType, createdAt: createdAt, isDismissible: isDismissible)
    let imageUrl = metaData[.image] as? String
    
    self.init(contentCardData: contentCardData, imageUrl: imageUrl)
  }
}
