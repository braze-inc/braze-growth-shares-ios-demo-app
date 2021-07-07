import UIKit

class OutOfTheBoxContentCardsConfigurationViewController: UIViewController {
  
  // MARK: - Variables
  private var configurationData = OutOfTheBoxConfigurationData()
  private var campaignType: OutOfTheBoxContentCardCampaignType {
    return OutOfTheBoxContentCardCampaignType(rawValue: segmentedControl.selectedSegmentIndex) ?? .banner
  }
  
  // MARK: - Outlets
  @IBOutlet private weak var stackView: UIStackView!
  @IBOutlet private weak var segmentedControl: UISegmentedControl!
  @IBOutlet private weak var triggerCampaignButton: UIButton!
  
  // MARK: - Actions
  @IBAction func exitButtonPressed(_ sender: Any) {
    dismiss(animated: true)
  }
  
  @IBAction func segmentChanged(_ sender: Any) {
    triggerCampaignButton.setTitle("\(campaignType.stringRepresentation) CAMPAIGN", for: .normal)
  }
  
  @IBAction func triggerCampaignButtonPressed(_ sender: Any) {
    guard let userId = BrazeManager.shared.userId, !userId.isEmpty else { return }
    handleApiTriggeredCampaignKey(userId)
  }
}

extension OutOfTheBoxContentCardsConfigurationViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let fontView: FontConfigurationView = .fromNib()
    fontView.configureView(delegate: self)
    stackView.addArrangedSubview(fontView)
    
    let cornerRadiusView: SliderConfigurationView = .fromNib()
    cornerRadiusView.configureView("Corner Radius", value: configurationData.cornerRadius, maxValue: 50, tag: 0, delegate: self)
    stackView.addArrangedSubview(cornerRadiusView)
    
    let borderWidthView: SliderConfigurationView = .fromNib()
    borderWidthView.configureView("Border Width", value: configurationData.borderWidth, maxValue: 10, tag: 1, delegate: self)
    stackView.addArrangedSubview(borderWidthView)
    
    let colorView: ColorConfigurationView = .fromNib()
    let colorViewAttributes = [("Border", configurationData.color.border), ("Background", configurationData.color.background), ("Label", configurationData.color.label), ("Link", configurationData.color.link), ("Unread", configurationData.color.link)]
    colorView.configureView(viewAttributes: colorViewAttributes, delegate: self)
    stackView.addArrangedSubview(colorView)
    
    let spacerView = UIView()
    spacerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    stackView.addArrangedSubview(spacerView)
  }
}

// MARK: Color Box Action Delegate
extension OutOfTheBoxContentCardsConfigurationViewController: ColorBoxActionDelegate {
  func colorDidUpdate(newColor: UIColor, tag: Int) {
    switch tag {
    case 0:
      configurationData.color.border = newColor
    case 1:
      configurationData.color.background = newColor
    case 2:
      configurationData.color.label = newColor
    case 3:
      configurationData.color.link = newColor
    case 4:
      configurationData.color.unread = newColor
    default: break
    }
  }
  
  func boxDidPress(currentColor: UIColor?, colorPickerDelegate: UIColorPickerViewControllerDelegate) {
    let colorPicker = UIColorPickerViewController()
    colorPicker.selectedColor = currentColor!
    colorPicker.delegate = colorPickerDelegate
    present(colorPicker, animated: true, completion: nil)
  }
}

// MARK: - Font Action Delegate
extension OutOfTheBoxContentCardsConfigurationViewController: FontActionDelegate {
  func fontDidUpdate(style: String) {
    configurationData.fontStyle = style
  }
}

// MARK: Slider Action Delegate
extension OutOfTheBoxContentCardsConfigurationViewController: SliderActionDelegate {
  func sliderDidUpdate(newValue: Float, tag: Int) {
    switch tag {
    case 0:
      configurationData.cornerRadius = newValue
    case 1:
      configurationData.borderWidth = newValue
    default: break
    }
  }
}

// MARK: - Private
private extension OutOfTheBoxContentCardsConfigurationViewController {
  func handleApiTriggeredCampaignKey(_ userId: String) {
    let campaignId = campaignType.campaignId
    let campaignAPIKey = "YOUR-CAMPAIGN-API-KEY"
    let triggerProperties = ["font_style": configurationData.fontStyle,
                             "corner_radius": String(configurationData.cornerRadius),
                             "border_width": String(configurationData.borderWidth),
                             "border_color": configurationData.color.border.hexValue(),
                             "background_color": configurationData.color.background.hexValue(),
                             "label_color": configurationData.color.label.hexValue(),
                             "link_color": configurationData.color.link.hexValue(),
                             "unread_color": configurationData.color.unread.hexValue()]
    
    let request = APITriggeredCampaignRequest(campaignId: campaignId, campaignAPIKey: campaignAPIKey, userId: userId, triggerProperties: triggerProperties)
    
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
}
