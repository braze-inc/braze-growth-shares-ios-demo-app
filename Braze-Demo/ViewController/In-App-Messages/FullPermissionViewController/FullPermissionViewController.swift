import UIKit

class FullPermissionViewController: FullViewController {
  
  override var nibName: String {
    return "FullPermissionViewController"
  }
}

// MARK: - View Lifecycle
extension FullPermissionViewController {
  override func loadView() {
    Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    inAppMessageHeaderLabel?.textAlignment = .center
  }
}
