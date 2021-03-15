import UIKit

class SlideFromBottomViewController: SlideupViewController {
  
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

// MARK: - Bottom Spacing Variables
private extension SlideFromBottomViewController {
  // MARK: - Variables
  var brazeDefaultVerticalMarginHeight: CGFloat {
    return 10
  }
  
  /// See the `safeAreaOffset` value from the `ABKInAppMessageSlideupViewController.m` file.
  ///
  /// On devices such as the iPhone SE, we only want to negate the `DefaultVerticalMarginHeight` if there is no bottom tab bar.
  var safeAreaOffset: CGFloat {
    guard view.superview?.layoutMargins.bottom == 0,
          bottomSpacing != 0 else { return 0 }
    
    return brazeDefaultVerticalMarginHeight
  }
  
  var rootViewBottomSpacing: CGFloat {
    return BrazeManager.shared.activeApplicationViewController.view.safeAreaInsets.bottom
  }
  
  var topMostViewBottomSpacing: CGFloat {
    return BrazeManager.shared.activeApplicationViewController.topMostViewController().view.safeAreaInsets.bottom
  }
  
  /// Calculating the net `safeAreaInsets.bottom` value from the top most view controller and the root view controller.
  ///
  /// In order to position the `SlideFromBottomViewController` above the tab bar (if present).
  var bottomSpacing: CGFloat {
    return  topMostViewBottomSpacing - rootViewBottomSpacing
  }
}

// MARK: - View Lifecycle
extension SlideFromBottomViewController {
  /// Overriding this method to provide our own custom value for `offset`
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
    offset = -(bottomSpacing - safeAreaOffset)
  }
}
