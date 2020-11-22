import UIKit

class ExpandableViewController: SlideupViewController {
  
  // MARK: - Outlets
  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var imageHeightConstraint: NSLayoutConstraint!
  
  // MARK: - Actions
  @IBAction func sheetPressed(_ sender: Any) {
    inAppMessage.logInAppMessageClicked()
    
    increaseHeight()
  }
}

// MARK: - View Lifecycle
extension ExpandableViewController {
  override func loadView() {
    Bundle.main.loadNibNamed("SheetViewController", owner: self, options: nil)
    
    ImageCache.sharedCache.image(from: inAppMessage.imageURI) { image in
      self.imageView.image = image
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.slideConstraint?.constant = 84
  }
}

// MARK: - Private
private extension ExpandableViewController {
  @objc func increaseHeight() {
    self.imageHeightConstraint.constant = 300
    UIView.animate(withDuration: 0.75) {
      self.view.superview?.layoutIfNeeded()
    }
  }
}
