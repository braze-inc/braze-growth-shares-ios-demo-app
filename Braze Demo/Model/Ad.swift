import Foundation

struct Ad: ContentCardable {
  let contentCardData: ContentCardData?
  let imageUrl: String?
}

extension Ad {
  init?(metaData: [ContentCardKey: Any], classType contentCardClassType: ContentCardClassType) {
    guard let contentCardId = metaData[.idString] as? String,
      let createdAt = metaData[.created] as? Double,
      let isDismissable = metaData[.dismissable] as? Bool
      else { return nil }
    
    let contentCardData = ContentCardData(contentCardId: contentCardId, contentCardClassType: contentCardClassType, createdAt: createdAt, isDismissable: isDismissable)
    let imageUrl = metaData[.image] as? String
    
    
    self.init(contentCardData: contentCardData, imageUrl: imageUrl)
  }
}
