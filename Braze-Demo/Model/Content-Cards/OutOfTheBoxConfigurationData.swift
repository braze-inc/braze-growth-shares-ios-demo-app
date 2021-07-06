import UIKit

struct OutOfTheBoxConfigurationData {
  
  var fontStyle: String = ""
  var cornerRadius: Float = 3
  var borderWidth: Float = 0
  var color = ColorConfigurationData()
  
  struct ColorConfigurationData {
    var border: UIColor = .black
    var background: UIColor = .systemBackground
    var label: UIColor = .label
    var link: UIColor = .link
    var unread: UIColor = .link
  }
}

enum OutOfTheBoxContentCardCampaignType: Int {
  case banner
  case captionedImage
  case classic
  
  var stringRepresentation: String {
    switch self {
    case .banner: return "BANNER"
    case .captionedImage: return "CAPTIONED IMAGE"
    case .classic: return "CLASSIC"
    }
  }
  
  var campaignId: String {
    switch self {
    case .banner: return "YOUR-BANNER-CAMPAIGN-ID"
    case .captionedImage: return "YOUR-CAPTIONED-IMAGE-CAMPAIGN-ID"
    case .classic: return "YOUR-CLASSIC-CAMPAIGN-ID"
    }
  }
}
