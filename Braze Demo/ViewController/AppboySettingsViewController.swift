import UIKit

class AppboySettingsViewController: UIViewController {

  // MARK: - Outlets
  @IBOutlet private weak var externalIDTextField: UITextField! {
    didSet {
      guard let userId = AppboyManager.shared.userId, !userId.isEmpty else { return }
      externalIDTextField.text = userId
    }
  }
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  
  // MARK: - Actions
  @IBAction func changeUserButtonPressed(_ sender: Any) {
    guard let userId = externalIDTextField.text else { return }
    AppboyManager.shared.changeUser(userId)
    
    presentAlert(title: "Changed User ID to \(userId)", message: nil)
  }
  @IBAction func customAttributeButtonPressed(_ sender: Any) {
    guard let button = sender as? UIButton else { return }
    handleCustomAttrributeButtonPressed(button)
    
    UINotificationFeedbackGenerator().notificationOccurred(.success)
  }
  @IBAction func apiTriggeredCampaignButtonPressed(_ sender: Any) {
    guard let userId = externalIDTextField.text, !userId.isEmpty else { return }
    handleApiTriggeredCampaignKey(userId)
  }
  @IBAction func segmentChanged(_ sender: Any) {
    guard let segmentedControl = sender as? UISegmentedControl else { return }
    
    RemoteStorage().store(segmentedControl.selectedSegmentIndex, forKey: RemoteStorageKey.messageCenterStyle.rawValue)
  }
  @IBAction func messageCenterCampaignButtonPressed(_ sender: Any) {
    guard let button = sender as? UIButton else { return }
    handleMessageCenterCampaignButtonPressed(with: button.tag)
  }
}

// MARK: - View Lifecycle
extension AppboySettingsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureMessageCenterSegmentedControl()
  }
}

// MARK: - Private Methods
private extension AppboySettingsViewController {
  func configureMessageCenterSegmentedControl() {
    if let value = RemoteStorage().retrieve(forKey: RemoteStorageKey.messageCenterStyle.rawValue) as? Int {
      segmentedControl.selectedSegmentIndex = value
    }
  }
  
  func handleCustomAttrributeButtonPressed(_ button: UIButton) {
    var attributeTitle = ""
    switch button.tag {
    case 0:
      attributeTitle = "Chicago Cubs"
    case 1:
      attributeTitle = "Chicago White Sox"
    default:
      return
    }
    AppboyManager.shared.setCustomAttributeWithKey("Favorite Team", andStringValue: attributeTitle)
    presentAlert(title: "Favorite Team changed to \(attributeTitle)", message: nil)
  }
  
  func handleApiTriggeredCampaignKey(_ userId: String) {
    let tileCampaignId = "YOUR-CAMPAIGN-ID"
    let tileCampaignAPIKey = "YOUR-CAMPAIGN-API-KEY"
    let tileTriggerProperties = ["tile_title": "Currents 101 Live Training", "tile_image": "https://cc.sj-cdn.net/instructor/2mwq54fjyfsk3-braze/courses/2bffl8kjacmwy/promo-image.1585681509.png", "tile_price": "250.00", "tile_tags": "Currents", "tile_deeplink": ""]
    
    let request = APITriggeredCampaignRequest(campaignId: tileCampaignId, campaignAPIKey: tileCampaignAPIKey, userId: userId, triggerProperties: tileTriggerProperties)
    
    APIURLRequest().make(request: request) { [weak self] (result: APIResult<[String:String]>) in
      guard let self = self else { return }
      
      var alertTitle = ""
      switch result {
      case .success(let response):
        alertTitle = response.description
      case .failure(let title):
        alertTitle = title
      }
      
      DispatchQueue.main.async {
        self.presentAlert(title: alertTitle, message: nil)
      }
    }
  }
  
  func handleMessageCenterCampaignButtonPressed(with tag: Int) {
    var eventTitle = ""
    switch tag {
    case 0:
      eventTitle = "Full Page Pressed"
    case 1:
      eventTitle = "HTML Pressed"
    case 2:
      eventTitle = "URL Pressed"
    default:
      break
    }
    AppboyManager.shared.logCustomEvent(eventTitle)
    presentAlert(title: eventTitle, message: nil)
  }
}
