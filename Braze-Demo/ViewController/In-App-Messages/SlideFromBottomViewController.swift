import UIKit

class SlideFromBottomViewController: SlideupViewController {

  // MARK: - Variables
  private let DefaultVerticalMarginHeight: CGFloat = 10
  
  private var safeAreaOffset: CGFloat {
    guard view.superview?.layoutMargins.bottom == 0,
          bottomSpacing != 0 else { return 0 }
    
    return -DefaultVerticalMarginHeight
  }
  
  private var bottomSpacing: CGFloat {
    return BrazeManager.shared.activeApplicationViewController.topMostViewController().view.safeAreaInsets.bottom - BrazeManager.shared.activeApplicationViewController.view.safeAreaInsets.bottom
  }
  
  // MARK: ABK Variables
  override var offset: CGFloat {
    get {
      return bottomSpacing
    }
    set {
      super.offset = newValue
    }
  }
}

// MARK: - View Lifecycle
extension SlideFromBottomViewController {
  override func beforeMoveInAppMessageViewOnScreen() {
    super.beforeMoveInAppMessageViewOnScreen()
    
    setOffset()
  }
  
  // When subclassing ABKInAppMessageSlideupViewController, we have to manually handle orienation changes
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { context in
      self.setOffset()
    }, completion: nil)
  }
}

// MARK: - Private
private extension SlideFromBottomViewController {
  func setOffset() {
    offset = (-bottomSpacing - safeAreaOffset)
  }
}
