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

struct ConfigurationData {
  var cornerRadius: Int = 0
  var borderWidth: Int = 0
  var borderColor: String = "FFFFFF"
  var backgroundColor: String = "000000"
  var labelColor: String = "FFFFFF"
  var linkColor: String = "FFFFFF"
}

class OutOfTheBoxContentCardsViewController: UIViewController {
  
  // MARK: - Variables
  private var configurationData = ConfigurationData()
  private let colorView: ColorConfigurationView = .fromNib()
  private var campaignType: ContentCardCampaignType {
    return ContentCardCampaignType(rawValue: segmentedControl.selectedSegmentIndex) ?? .banner
  }
  
  // MARK: - Outlets
  @IBOutlet weak var stackView: UIStackView!
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

extension OutOfTheBoxContentCardsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let cornerRadiusView: SliderConfigurationView = .fromNib()
    cornerRadiusView.configureView("Corner Radius", maxValue: 50, intervalValue: 5)
    cornerRadiusView.tag = 0
    stackView.addArrangedSubview(cornerRadiusView)
    
    let borderWidthView: SliderConfigurationView = .fromNib()
    borderWidthView.configureView("Border Width", maxValue: 20, intervalValue: 5)
    borderWidthView.tag = 0
    stackView.addArrangedSubview(borderWidthView)
    
    colorView.configureView(self)
    stackView.addArrangedSubview(colorView)
  }
}

// MARK: Configuration View Delegate
extension OutOfTheBoxContentCardsViewController: ColorBoxActionDelegate {
  func colorDidUpdate(newColor: UIColor, tag: Int) {
    switch tag {
    case 0: configurationData.borderColor = newColor.hexValue()
    case 1: configurationData.backgroundColor = newColor.hexValue()
    case 2: configurationData.labelColor = newColor.hexValue()
    case 3: configurationData.linkColor = newColor.hexValue()
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
