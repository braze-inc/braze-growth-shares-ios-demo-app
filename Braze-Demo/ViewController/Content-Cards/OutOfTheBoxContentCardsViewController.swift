import UIKit

enum ContentCardCampaignType: Int {
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
}

class OutOfTheBoxContentCardsViewController: UIViewController {
  
  // MARK: - Variables
  private var campaignType: ContentCardCampaignType {
    return ContentCardCampaignType(rawValue: segmentedControl.selectedSegmentIndex) ?? .banner
  }
  
  // MARK: - Outlets
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var triggerCampaignButton: UIButton!
  
  // MARK: - Actions
  @IBAction func exitButtonPressed(_ sender: Any) {
    dismiss(animated: true)
  }
  
  @IBAction func segmentChanged(_ sender: Any) {
    triggerCampaignButton.setTitle("\(campaignType.stringRepresentation) CAMPAIGN", for: .normal)
  }
  
  @IBAction func triggerCampaignButtonPressed(_ sender: Any) {
  }
}
