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
  private var animator: UIViewPropertyAnimator!
  private var topConstraint: NSLayoutConstraint?
  private weak var delegate: SheetViewActionDelegate?
  
  // MARK: - IBActions
  @IBAction func viewDidPan(_ sender: UIPanGestureRecognizer) {
    handleViewDidPan(sender)
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
  
  private var midwayPoint: CGFloat {
    return (fullPagePoint + slideUpPoint) / 2
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
    
    let visualEffectView = UIVisualEffectView()
    visualEffectView.isUserInteractionEnabled = false
    visualEffectView.frame = viewController.view.frame
    viewController.view.addSubview(visualEffectView)
      
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
    animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.5, animations: {
      self.topConstraint?.constant = state == .slideUp ? self.slideUpPoint : self.fullPagePoint
      self.delegate?.view.layoutIfNeeded()
    })
    
    animator.startAnimation()
    
    sheetViewState = state
  }
}

// MARK: - Private
private extension SheetViewController {
  func handleViewDidPan(_ recognizer: UIPanGestureRecognizer) {
    guard let gestureView = recognizer.view else { return }
    
    let velocity = recognizer.velocity(in: gestureView)
    
    switch recognizer.state {
    case .began: break
    case .changed:
      guard let topConstraint = topConstraint else { return }
      if topConstraint.constant > fullPagePoint && velocity.y < 0 { recognizer.state = .cancelled }
      
      let translation = recognizer.translation(in: delegate?.view)
      topConstraint.constant -= translation.y
      recognizer.setTranslation(.zero, in: delegate?.view)
    case .ended, .cancelled:
      guard let topConstraint = topConstraint else { return }
      
      if topConstraint.constant > fullPagePoint {
        animatePoint(.fullPage)
      } else {
        sheetViewState = topConstraint.constant > midwayPoint ? .fullPage : .slideUp
        
        animatePoint(sheetViewState)
      }
    default:
        break
    }
  }
}
