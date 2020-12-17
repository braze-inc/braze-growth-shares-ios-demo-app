import UIKit
import Appboy_iOS_SDK

class SlideFromBottomViewController: ABKInAppMessageSlideupViewController {

  // MARK: - Variables
  private var bottomSpacing: CGFloat {
    return ABKUIUtils.activeApplicationViewController.topMostViewController().view.safeAreaInsets.bottom
  }
}

// MARK: - View Lifecycle
extension SlideFromBottomViewController {
  /// Overriding this method to provide our own custom value for `slideConstraint`
  override func beforeMoveInAppMessageViewOnScreen() {
    setSlideConstraint()
  }
  
  // When subclassing ABKInAppMessageSlideupViewController, we have to manually handle orienation changes
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
    slideConstraint?.constant = bottomSpacing
  }
}
