import UIKit

class SheetViewController: SlideupViewController {
  
  // MARK: - Outlets
  @IBOutlet private weak var imageHeightConstraint: NSLayoutConstraint!
  
  // MARK: - Actions
  @IBAction func sheetPressed(_ sender: Any) {
    inAppMessage.logInAppMessageClicked()
    
    increaseHeight()
  }
}

// MARK: - View Lifecycle
extension SheetViewController {
  override func loadView() {
    Bundle.main.loadNibNamed("SheetViewController", owner: self, options: nil)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.slideConstraint?.constant = 84
  }
}

// MARK: - Private
private extension SheetViewController {
  @objc func increaseHeight() {
    self.imageHeightConstraint.constant = 300
    UIView.animate(withDuration: 1.0) {
      self.view.superview?.layoutIfNeeded()
    }
  }
}
