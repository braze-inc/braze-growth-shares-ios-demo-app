import UIKit

class FullPermissionViewController: FullViewController {
  
  // MARK: - Outlets
  @IBOutlet private weak var permissionView: UIView!
  @IBOutlet private weak var arrowView: UIView!
  @IBOutlet private weak var permissionTitle: UILabel!
  @IBOutlet private weak var permissionSubtitle: UILabel!
  
  override var nibName: String {
    return "FullPermissionViewController"
  }
}

// MARK: - View Lifecycle
extension FullPermissionViewController {
  override func loadView() {
    Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let titleText = inAppMessage.extras?["permission_title"] as? String {
      permissionTitle.text = titleText
    }
    
    if let subtitleText = inAppMessage.extras?["permission_subtitle"] as? String {
      permissionSubtitle.text = subtitleText
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    inAppMessageHeaderLabel?.textAlignment = .center
  }
}
