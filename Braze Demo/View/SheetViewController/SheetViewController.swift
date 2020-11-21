import UIKit

protocol SheetViewActionDelegate where Self: UIViewController {
  func sheetViewDidDismiss()
}

enum SheetViewState {
  case slideUp
  case fullPage
  case offScreen
}

class SheetViewController: SlideUpViewController {
  
  // MARK: - Outlets
  @IBOutlet weak var heightConstraint: NSLayoutConstraint?
  
  // MARK: - Variables
  private var sheetViewState: SheetViewState!
  private weak var delegate: SheetViewActionDelegate?
  
  // MARK: - IBActions
  @IBAction func viewDidPan(_ sender: UIPanGestureRecognizer) {
    handleViewDidPan(sender)
  }
  @IBAction func viewDidSwipe(_ sender: UISwipeGestureRecognizer) {
    handleViewDidSwipe(sender)
  }
}

// MARK: - View Properties
extension SheetViewController {
  private var fullPagePoint: CGFloat {
    return view.frame.height - 200
  }
  private var slideUpPoint: CGFloat {
    return 200
  }
  private var bottomThirdPoint: CGFloat {
    return (fullPagePoint + slideUpPoint) / 3
  }
}

// MARK: - View Lifecycle
extension SheetViewController {
  override func loadView() {
    Bundle.main.loadNibNamed("SheetViewController", owner: self, options: nil)
    sheetViewState = .slideUp
  }
}

// MARK: - Public
extension SheetViewController {
  func animatePoint(_ state: SheetViewState) {
    let sheetAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.75, animations: {
      var constraintPoint: CGFloat = 0.0
      switch state {
      case .slideUp:
        constraintPoint = self.slideUpPoint
      case .fullPage:
        constraintPoint = self.fullPagePoint
      case .offScreen:
        break
      }
      self.heightConstraint?.constant = constraintPoint
      self.delegate?.view.layoutIfNeeded()
    })
    sheetAnimator.startAnimation()
    
    sheetViewState = state
    
    animateAlpha(state == .fullPage ? 0.75 : 0, animate: true)
  }
  
  func dismiss() {

  }
}

// MARK: - Private
private extension SheetViewController {
  func handleViewDidPan(_ recognizer: UIPanGestureRecognizer) {
    guard let heightConstraint = heightConstraint else { return }
    switch recognizer.state {
    case .began: break
    case .changed:
      if heightConstraint.constant > fullPagePoint { recognizer.state = .cancelled }
      
      let translation = recognizer.translation(in: delegate?.view)
      heightConstraint.constant += translation.y
      recognizer.setTranslation(.zero, in: delegate?.view)
    
      let fractionComplete = (heightConstraint.constant - slideUpPoint) / fullPagePoint
      animateAlpha(fractionComplete)
    case .ended, .cancelled:
      sheetViewState = heightConstraint.constant > bottomThirdPoint ? .fullPage : .slideUp
      animatePoint(sheetViewState)
    default:
        break
    }
  }
  
  func handleViewDidSwipe(_ recognizer: UISwipeGestureRecognizer) {
    switch recognizer.direction {
    case .down:
      if sheetViewState != .slideUp {
        animatePoint(.slideUp)
      } else {
        dismiss()
      }
    default:
      break
    }
  }
  
  func animateAlpha(_ alpha: CGFloat, animate: Bool = false) {
  }
}

extension SheetViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
           shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
     if gestureRecognizer is UISwipeGestureRecognizer &&
            otherGestureRecognizer is UIPanGestureRecognizer {
        return true
     }
     return false
  }
}
