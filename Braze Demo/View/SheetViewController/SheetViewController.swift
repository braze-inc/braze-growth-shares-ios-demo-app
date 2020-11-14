import UIKit

protocol SheetViewActionDelegate: class {
  func sheetViewDidPan()
  func sheetViewDidStopPanning()
  func sheetViewDidSwipeToDismiss()
}

class SheetViewController: UIViewController {
  
  enum SheetViewState {
    case slideUp
    case fullPage
  }
  
  var sheetViewState: SheetViewState!
  var animator: UIViewPropertyAnimator!
  var topConstraint: NSLayoutConstraint?
  private weak var delegate: SheetViewActionDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func addSheet(to viewController: UIViewController) {
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
      view.heightAnchor.constraint(equalToConstant: 600)
    ])
  }
  
  func appearSlideUp(_ superview: UIView) {
    animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.5, animations: {
      self.topConstraint?.constant = 200
      superview.layoutIfNeeded()
    })
    
    animator.startAnimation()
    sheetViewState = .slideUp
  }
  
  @IBAction func viewDidPan(_ sender: UIPanGestureRecognizer) {
    switch sender.state {
    case .began: break
    case .changed: break
    case .ended: break
    default:
        break
    }
  }
}
