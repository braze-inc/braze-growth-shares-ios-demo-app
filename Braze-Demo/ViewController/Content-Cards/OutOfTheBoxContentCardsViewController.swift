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
extension OutOfTheBoxContentCardsViewController: ConfigurationViewDelegate {
  func colorPressed(_ currentColor: UIColor?) {
    let colorPicker = UIColorPickerViewController()
    colorPicker.selectedColor = currentColor!
    colorPicker.delegate = self
    present(colorPicker, animated: true, completion: nil)
  }
}

// MARK: Color Picker Delegate
extension OutOfTheBoxContentCardsViewController: UIColorPickerViewControllerDelegate {
  func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
    let newColor = viewController.selectedColor
    colorView.setBackgroundColor(newColor)
  }
}
