import UIKit

protocol SheetViewActionDelegate where Self: UIViewController {
  func sheetViewDidPan()
  func sheetViewDidStopPanning()
  func sheetViewDidSwipeToDismiss()
}

enum SheetViewState {
  case slideUp
  case fullPage
}

class SheetViewController: UIViewController {
  
  // MARK: - Variables
  private var sheetViewState: SheetViewState!
  private let backgroundView = UIView()
  private var topConstraint: NSLayoutConstraint?
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
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

// MARK: - Public
extension SheetViewController {
  func addSheet(to viewController: SheetViewActionDelegate) {
    delegate = viewController
    
    backgroundView.isUserInteractionEnabled = false
    backgroundView.backgroundColor = .black
    backgroundView.alpha = 0
    viewController.view.addSubview(backgroundView)
    
    backgroundView.translatesAutoresizingMaskIntoConstraints = false
    let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .trailing, .leading]
    NSLayoutConstraint.activate(attributes.map {
      NSLayoutConstraint(item: backgroundView, attribute: $0, relatedBy: .equal, toItem: viewController.view, attribute: $0, multiplier: 1, constant: 0)
    })
      
    viewController.addChild(self)
    view.translatesAutoresizingMaskIntoConstraints = false
    viewController.view.addSubview(view)
    
    topConstraint = NSLayoutConstraint(item: viewController.view!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
    topConstraint?.isActive = true
    
    NSLayoutConstraint.activate([
      view.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 0),
      view.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: 0),
      view.heightAnchor.constraint(equalTo: viewController.view.heightAnchor, multiplier: 1)
    ])
  }
  
  func animatePoint(_ state: SheetViewState) {
    let sheetAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.75, animations: {
      self.topConstraint?.constant = state == .slideUp ? self.slideUpPoint : self.fullPagePoint
      self.delegate?.view.layoutIfNeeded()
    })
    sheetAnimator.startAnimation()
    
    sheetViewState = state
    
    animateAlpha(state == .fullPage ? 0.75 : 0, animate: true)
  }
}

// MARK: - Private
private extension SheetViewController {
  func handleViewDidPan(_ recognizer: UIPanGestureRecognizer) {
    guard let topConstraint = topConstraint else { return }
    switch recognizer.state {
    case .began: break
    case .changed:
      if topConstraint.constant > fullPagePoint { recognizer.state = .cancelled }
      
      let translation = recognizer.translation(in: delegate?.view)
      topConstraint.constant -= translation.y
      recognizer.setTranslation(.zero, in: delegate?.view)
    
      let fractionComplete = (topConstraint.constant - slideUpPoint) / fullPagePoint
      animateAlpha(fractionComplete)
    case .ended, .cancelled:
      sheetViewState = topConstraint.constant > bottomThirdPoint ? .fullPage : .slideUp
      animatePoint(sheetViewState)
    default:
        break
    }
  }
  
  func handleViewDidSwipe(_ recognizer: UISwipeGestureRecognizer) {
    switch recognizer.direction {
    case .down:
      animatePoint(.slideUp)
    default:
      break
    }
  }
  
  func animateAlpha(_ alpha: CGFloat, animate: Bool = false) {
    UIView.animate(withDuration: animate ? 0.25 : 0.0) {
      self.backgroundView.alpha = alpha
    }
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
