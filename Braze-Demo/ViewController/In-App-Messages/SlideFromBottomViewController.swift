import UIKit

class SlideFromBottomViewController: SlideupViewController {
  
  // MARK: ABK Variables
  override var offset: CGFloat {
    get {
      return super.offset
    }
    set {
      super.offset = newValue + adjustedOffset
    }
  }
}

// MARK: - Bottom Spacing Variables
private extension SlideFromBottomViewController {
  /// See the `DefaultVerticalMarginHeight` value from the `ABKInAppMessageSlideupViewController.m` file.
  var brazeDefaultVerticalMarginHeight: CGFloat {
    return 10
  }
  
  var rootViewBottomSpacing: CGFloat {
    return BrazeManager.shared.activeApplicationViewController.view.safeAreaInsets.bottom
  }
  
  var topMostViewBottomSpacing: CGFloat {
    return BrazeManager.shared.activeApplicationViewController.topMostViewController().view.safeAreaInsets.bottom
  }
  
  /// Calculating the net `safeAreaInsets.bottom` value from the top most view controller and the root view controller in order to position the `SlideFromBottomViewController` above the tab bar (if present).
  var bottomSpacing: CGFloat {
    return  topMostViewBottomSpacing - rootViewBottomSpacing
  }
  
  
  /// See the `safeAreaOffset` value from the `ABKInAppMessageSlideupViewController.m` file.
  ///
  /// On devices such as the iPhone SE, we only want to negate the `DefaultVerticalMarginHeight` if there is no bottom tab bar.
  var safeAreaOffset: CGFloat {
    guard view.superview?.layoutMargins.bottom == 0,
          bottomSpacing != 0 else { return 0 }
    
    return brazeDefaultVerticalMarginHeight
  }
  
  /// Used in the `offset` setter value to set the correct value when presented on screen and when dragged. (see `inAppSlideupWasPanned` in `ABKInAppMessageWindowController.m`)
  var adjustedOffset: CGFloat {
    return -(bottomSpacing - safeAreaOffset)
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
    offset = 0
  }
}
