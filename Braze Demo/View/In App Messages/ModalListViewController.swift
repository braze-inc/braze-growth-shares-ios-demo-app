import UIKit

class ModalListViewController: ModalViewController {

  // MARK: - Outlets
  @IBOutlet private weak var pickerView: UIPickerView!
  
  // MARK: - Variables
  override var nibName: String {
    return "ModalListViewController"
  }
  
  private var teams = [Team]()
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
      case .success(let teams):
        self.teams = teams
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
  
}

extension ModalListViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return teams.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return teams[row].title
  }
}
