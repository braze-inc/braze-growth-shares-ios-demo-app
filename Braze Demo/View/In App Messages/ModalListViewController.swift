import UIKit

class ModalListViewController: ModalViewController {

  // MARK: - Outlets
  @IBOutlet private weak var pickerView: UIPickerView!
  
  // MARK: - Actions
  @IBAction func primaryButtonTapped(_ sender: Any) {
    guard let item = selectedItem, !item.isEmpty, let attributeKey = inAppMessage.extras?["attribute_name"] as? String else { return }
    
    AppboyManager.shared.setCustomAttributeWithKey(attributeKey, andStringValue: item)
  }
  
  // MARK: - Variables
  override var nibName: String {
    return "ModalListViewController"
  }
  private var items = [Team]()
  private var selectedItem: String?
}

// MARK: - View Lifecycle
extension ModalListViewController {
  override func loadView() {
    Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let request = TeamListRequest()
    APIURLRequest().make(request: request) { [weak self] (result: APIResult<[Team]>) in
      guard let self = self else { return }
      
      switch result {
      case .success(let items):
        self.items = items
        self.items.insert(Team(teamID: "", abbreviation: "", title: ""), at: 0)
        DispatchQueue.main.async {
          self.pickerView.reloadAllComponents()
        }
      case .failure(let title):
       print(title)
      }
    }
  }
}

extension ModalListViewController: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    rightInAppMessageButton?.isEnabled = row != 0
    
    selectedItem = items[row].title
  }
}

extension ModalListViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return items.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return items[row].title
  }
}
