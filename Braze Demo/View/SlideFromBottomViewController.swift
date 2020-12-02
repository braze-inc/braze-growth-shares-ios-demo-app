import UIKit

class SlideFromBottomViewController: SlideupViewController {

  // MARK: - Variables
  private let tabBarHeight: CGFloat = 50
}

// MARK: - View Lifecycle
extension SlideFromBottomViewController {
  override func beforeMoveInAppMessageViewOnScreen() {
    setSlideConstraint()
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { context in
      self.setSlideConstraint()
    }, completion: nil)
  }
}

// MARK: - Private
private extension SlideFromBottomViewController {
  func setSlideConstraint() {
    guard let superview = view.superview else { return }
    
    slideConstraint?.constant = superview.safeAreaInsets.bottom + tabBarHeight
  }
}
