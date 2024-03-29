import UIKit

class OutOfTheBoxContentCardsConfigurationViewController: UIViewController {
  
  // MARK: - Variables
  private var configurationData = OutOfTheBoxContentCardConfigurationData()
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
    guard let userId = BrazeManager.shared.userId, !userId.isEmpty else {
      return presentAlert(title: "NO-EXTERNAL-ID", message: "Sign in to launch API Triggered Campaign")
    }
    handleApiTriggeredCampaignKey(userId)
  }
}

// MARK: - View Lifecycle
extension OutOfTheBoxContentCardsConfigurationViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureStackView()
  }
}

// MARK: - Private
private extension OutOfTheBoxContentCardsConfigurationViewController {
  func configureStackView() {
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
    let colorViewAttributes = [("Background", configurationData.color.background), ("Border", configurationData.color.border), ("Label", configurationData.color.label), ("Link", configurationData.color.link), ("Unread", configurationData.color.link)]
    colorView.configureView(viewAttributes: colorViewAttributes, delegate: self)
    stackView.addArrangedSubview(colorView)
    
    let spacerView = UIView()
    spacerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    stackView.addArrangedSubview(spacerView)
  }
  
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
    
    APIRequestBuilder.make(campaignId: campaignId, campaignAPIKey: campaignAPIKey, userId: userId, triggerProperties) { [weak self] alertTitle in
      guard let self = self else { return }
      
      DispatchQueue.main.async {
        self.presentAlert(title: alertTitle, message: nil)
      }
    }
  }
}

// MARK: Color Box Action Delegate
extension OutOfTheBoxContentCardsConfigurationViewController: ColorBoxActionDelegate {
  func colorDidUpdate(newColor: UIColor, tag: Int) {
    switch tag {
    case 0: configurationData.color.background = newColor
    case 1: configurationData.color.border = newColor
    case 2: configurationData.color.label = newColor
    case 3: configurationData.color.link = newColor
    case 4: configurationData.color.unread = newColor
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
    case 0: configurationData.cornerRadius = newValue
    case 1: configurationData.borderWidth = newValue
    default: break
    }
  }
}
