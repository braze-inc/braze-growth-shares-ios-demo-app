import UIKit

class SheetViewController: UIViewController {
  
  enum SheetViewState {
    case slideUp
    case fullPage
  }
  
  var sheetViewState: SheetViewState!
  var runningAnimations = [UIViewPropertyAnimator]()
  var animationProgressWhenInterrupted: CGFloat = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func addSheet(to viewController: UIViewController) {
    let visualEffectView = UIVisualEffectView()
    visualEffectView.frame = self.view.frame
    viewController.view.addSubview(visualEffectView)
      
    viewController.addChild(self)
    viewController.view.addSubview(view)
      
    view.frame = CGRect(x: 0, y: view.frame.height, width: viewController.view.bounds.width, height: 600)
    view.clipsToBounds = true
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
