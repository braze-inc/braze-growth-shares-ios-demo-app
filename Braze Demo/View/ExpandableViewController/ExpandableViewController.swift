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
  
  // MARK: - Variables
  private let tabBarHeight: CGFloat = 50
  override var nibName: String {
    return "ExpandableViewController"
  }
}

// MARK: - View Lifecycle
extension ExpandableViewController {
  override func loadView() {
    Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
    
    ImageCache.sharedCache.image(from: inAppMessage.imageURI) { image in
      self.imageView.image = image
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setSlideConstraint()
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { contetxt in
      self.setSlideConstraint()
    }, completion: nil)
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
  
  func setSlideConstraint() {
    guard let superview = view.superview else { return }
    slideConstraint?.constant = superview.safeAreaInsets.bottom + tabBarHeight
  }
}
