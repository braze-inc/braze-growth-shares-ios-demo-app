import Foundation

struct Coupon: ContentCardable {
  let contentCardData: ContentCardData?
  let discountPercentage: Decimal
  let imageUrl: String?
}

// MARK: - Computed Variables
extension Coupon {
  var discountMultipler: Decimal {
    return discountPercentage / 100
  }
}

extension Coupon {
  init?(metaData: [ContentCardKey: Any], classType contentCardClassType: ContentCardClassType) {
    guard let contentCardId = metaData[.idString] as? String,
      let createdAt = metaData[.created] as? Double,
      let isDismissable = metaData[.dismissable] as? Bool,
      let extras = metaData[.extras] as? [AnyHashable: Any],
      let discountPercentageString = extras[ContentCardKey.discountPercentage.rawValue] as? String,
      let discountPercentage = Decimal(string: discountPercentageString)
      else { return nil }
    
    let contentCardData = ContentCardData(contentCardId: contentCardId, contentCardClassType: contentCardClassType, createdAt: createdAt, isDismissable: isDismissable)
    let imageUrl = metaData[.image] as? String
    
    self.init(contentCardData: contentCardData, discountPercentage: discountPercentage, imageUrl: imageUrl)
  }
}
