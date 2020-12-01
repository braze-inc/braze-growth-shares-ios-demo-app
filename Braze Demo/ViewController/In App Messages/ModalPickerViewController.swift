import UIKit

class ModalPickerViewController: ModalViewController {

  // MARK: - Outlets
  @IBOutlet private weak var pickerView: UIPickerView!
  
  // MARK: - Actions
  @IBAction func primaryButtonTapped(_ sender: Any) {
    guard let item = selectedItem, !item.isEmpty, let attributeKey = inAppMessage.extras?[InAppMessageKey.attributeKey.rawValue] as? String else { return }
    
    AppboyManager.shared.setCustomAttributeWithKey(attributeKey, andStringValue: item)
  }
  
  // MARK: - Variables
  override var nibName: String {
    return "ModalPickerViewController"
  }
  private var items = [String]()
  private var selectedItem: String?
}

// MARK: - View Lifecycle
extension ModalPickerViewController {
  /// Overriding loadView() from ABKInAppMessageModalViewController to provide our own view for the In-App Message
  override func loadView() {
    Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    items = inAppMessage.message.separatedByCommaSpaceValue
    pickerView.reloadAllComponents()
  }
}

// MARK: - PickerView Delegate
extension ModalPickerViewController: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedItem = items[row]
    rightInAppMessageButton?.isEnabled = row != 0
  }
}

// MARK: - PickerView Data Source
extension ModalPickerViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return items.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return items[row]
  }
}
